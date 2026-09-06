//
//  AgentChatViewModel.swift
//  Solian Watch App
//
//  Created on 2026-09-06.
//

import Combine
import Foundation

/// State for one agent conversation: messages, streaming, and send.
/// Mirrors SynthPet's `ConversationController` + `_ConversationPageState`,
/// but uses watchOS patterns (ObservableObject, no Flutter widgets).
@MainActor
final class AgentChatViewModel: ObservableObject {
    // MARK: - Published state

    @Published private(set) var agents: [SnAgent] = []
    @Published private(set) var conversations: [SnAgentConversation] = []
    @Published private(set) var bubbles: [AgentBubble] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingConversations = false
    @Published private(set) var isBusy = false
    @Published var draft = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedAgentId: String?
    /// The conversation the list wants the thread to open. Set by the list;
    /// consumed by the thread's `.task` to trigger `openConversation`.
    @Published var pendingConversation: SnAgentConversation?
    /// Set to true when "New Chat" is tapped so the thread starts fresh.
    @Published var pendingNewChat = false

    private let appState: AppState
    private var activeConversationId: String?
    private var hasLoaded = false
    private var activeTask: Task<Void, Never>?

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Load

    func loadInitial() async {
        guard !hasLoaded, !isLoading else { return }
        await waitForCredentials()
        guard let token = appState.token, let serverUrl = appState.serverUrl else {
            // Credentials never became available. Don't leave a silently-empty
            // conversation list: route to the device-flow sign-in so the user
            // re-authenticates instead of seeing a dead panel.
            appState.requiresSignIn = true
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let agents = try await appState.networkService.fetchAgentList(token: token, serverUrl: serverUrl)
            self.agents = agents
            // Default to first agent if none selected
            if selectedAgentId == nil, let first = agents.first {
                selectedAgentId = first.id
            }
            hasLoaded = true
            // Load conversations after agents
            await loadConversations()
        } catch is CancellationError {
            // View teardown cancelled the task — never surface as an error.
        } catch let urlError as URLError where urlError.code == .cancelled {
            // Network cancelled (view disappeared or auth expired).
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadConversations() async {
        guard let token = appState.token, let serverUrl = appState.serverUrl else { return }
        isLoadingConversations = true
        defer { isLoadingConversations = false }

        do {
            let convos = try await appState.networkService.fetchAgentConversations(token: token, serverUrl: serverUrl)
            self.conversations = convos
        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Agent / Conversation selection

    func selectAgent(_ agentId: String) {
        guard agentId != selectedAgentId, !isBusy else { return }
        selectedAgentId = agentId
        activeConversationId = nil
        bubbles = []
    }

    /// Opens an existing conversation: loads its history into bubbles.
    func openConversation(_ conversation: SnAgentConversation) async {
        guard !isBusy else { return }
        await waitForCredentials()
        guard let token = appState.token, let serverUrl = appState.serverUrl else { return }

        activeConversationId = conversation.id
        selectedAgentId = conversation.agentId
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let messages = try await appState.networkService.fetchAgentMessages(
                conversationId: conversation.id,
                token: token,
                serverUrl: serverUrl
            )
            self.bubbles = messages.flatMap { bubblesFromMessage($0) }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Starts a new conversation (no history, just clears the timeline).
    func newConversation() {
        guard !isBusy else { return }
        activeConversationId = nil
        bubbles = []
    }

    func dismissError() {
        errorMessage = nil
    }

    /// Called by the thread view's `.task` to consume pending state and load.
    func consumePending() async {
        if pendingNewChat {
            pendingNewChat = false
            newConversation()
        } else if let convo = pendingConversation {
            pendingConversation = nil
            await openConversation(convo)
        }
    }

    // MARK: - Send

    func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isBusy else { return }
        guard let token = appState.token, let serverUrl = appState.serverUrl else { return }

        draft = ""
        // Append user bubble
        bubbles.append(AgentBubble(.user, text))
        isBusy = true
        errorMessage = nil

        activeTask?.cancel()
        activeTask = Task { [weak self] in
            guard let self else { return }
            do {
                // Create conversation if needed
                var convoId = self.activeConversationId
                if convoId == nil {
                    let agentId = self.selectedAgentId ?? "michan"
                    convoId = try await self.appState.networkService.createAgentConversation(
                        agentId: agentId,
                        token: token,
                        serverUrl: serverUrl
                    )
                    await MainActor.run {
                        self.activeConversationId = convoId
                    }
                    await self.loadConversations()
                }
                guard let convoId, !Task.isCancelled else { return }

                // Append a streaming assistant bubble
                await MainActor.run { self.bubbles.append(AgentBubble(.assistant, "", streaming: true)) }

                // Accumulate SSE events
                var accumulatedText = ""
                var assistantIndex = 0
                await MainActor.run { assistantIndex = self.bubbles.count - 1 }

                try await self.appState.networkService.runAgentConversation(
                    conversationId: convoId,
                    message: text,
                    token: token,
                    serverUrl: serverUrl,
                    onChunk: { [weak self] delta in
                        DispatchQueue.main.async {
                            guard let self, assistantIndex < self.bubbles.count else { return }
                            accumulatedText += delta
                            self.bubbles[assistantIndex].text = accumulatedText
                        }
                    },
                    onReasoning: { [weak self] delta in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            if let last = self.bubbles.last, last.kind == .thinking, last.streaming {
                                self.bubbles[self.bubbles.count - 1].text += delta
                            } else {
                                self.bubbles.append(AgentBubble(.thinking, delta, streaming: true))
                            }
                        }
                    },
                    onToolCall: { [weak self] id, name, args in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            self.bubbles.append(AgentBubble(.tool, name, toolCallId: id, args: args, toolRunning: true))
                        }
                    },
                    onToolResult: { [weak self] id, name, args, result in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            if let idx = self.bubbles.lastIndex(where: { $0.toolCallId == id }) {
                                self.bubbles[idx].toolRunning = false
                                self.bubbles[idx].toolResult = result
                                self.bubbles[idx].args = args
                                self.bubbles[idx].collapsed = true
                            }
                        }
                    },
                    onCompleted: { [weak self] content in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            if assistantIndex < self.bubbles.count {
                                self.bubbles[assistantIndex].text = content
                                self.bubbles[assistantIndex].streaming = false
                            } else {
                                self.bubbles.append(AgentBubble(.assistant, content))
                            }
                            for i in self.bubbles.indices where self.bubbles[i].kind == .thinking && self.bubbles[i].streaming {
                                self.bubbles[i].streaming = false
                                self.bubbles[i].collapsed = true
                            }
                        }
                    },
                    onError: { [weak self] error in
                        DispatchQueue.main.async {
                            guard let self else { return }
                            self.errorMessage = error
                            if assistantIndex < self.bubbles.count, self.bubbles[assistantIndex].text.isEmpty {
                                self.bubbles.remove(at: assistantIndex)
                            }
                        }
                    }
                )

                // Finalize remaining streaming bubbles
                await MainActor.run {
                    if assistantIndex < self.bubbles.count {
                        self.bubbles[assistantIndex].streaming = false
                    }
                    for i in self.bubbles.indices where self.bubbles[i].kind == .thinking && self.bubbles[i].streaming {
                        self.bubbles[i].streaming = false
                        self.bubbles[i].collapsed = true
                    }
                }
            } catch {
                await MainActor.run {
                    if !Task.isCancelled {
                        self.errorMessage = error.localizedDescription
                        if let last = self.bubbles.last, last.kind == .assistant, last.text.isEmpty {
                            self.bubbles.removeLast()
                        }
                    }
                }
            }
            await MainActor.run { self.isBusy = false }
        }
    }

    func abort() {
        activeTask?.cancel()
        activeTask = nil
        isBusy = false
        // Remove trailing streaming bubble
        if let last = bubbles.last, last.kind == .assistant, last.streaming {
            bubbles.removeLast()
        }
        // Finalize thinking
        for i in bubbles.indices where bubbles[i].kind == .thinking && bubbles[i].streaming {
            bubbles[i].streaming = false
            bubbles[i].collapsed = true
        }
    }

    // MARK: - Helpers

    private func waitForCredentials() async {
        // The first `.task` can run before the stored session's token refresh
        // finishes. Wait up to a generous window (matches ChatView); bail early
        // if sign-in is required (terminal refresh failure routes to the
        // device-flow sign-in).
        var waitCount = 0
        while appState.token == nil || appState.serverUrl == nil {
            if appState.requiresSignIn { return }
            guard waitCount < 60 else { return }
            try? await Task.sleep(for: .milliseconds(250))
            if Task.isCancelled { return }
            waitCount += 1
        }
    }

    /// Converts a persisted message into displayable bubbles.
    /// Mirrors SynthPet's `_bubblesFromMessage`.
    private func bubblesFromMessage(_ message: SnAgentMessage) -> [AgentBubble] {
        switch message.role {
        case "assistant":
            var result: [AgentBubble] = []
            // Reasoning (thinking trace)
            if let reasoning = message.reasoningContent, !reasoning.trimmingCharacters(in: .whitespaces).isEmpty {
                result.append(AgentBubble(.thinking, reasoning, collapsed: true))
            }
            // Tool calls
            for call in message.toolCalls {
                result.append(AgentBubble(.tool, call.name, toolCallId: call.id, args: parseArgs(call.arguments), toolResult: "completed", collapsed: true))
            }
            // Content
            if !message.content.trimmingCharacters(in: .whitespaces).isEmpty {
                result.append(AgentBubble(.assistant, message.content))
            }
            return result
        case "user":
            return [AgentBubble(.user, message.content)]
        default:
            return []
        }
    }

    private func parseArgs(_ json: String) -> [String: Any]? {
        guard let data = json.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return obj
    }
}
