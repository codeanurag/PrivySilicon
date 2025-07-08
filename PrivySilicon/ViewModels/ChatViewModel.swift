//
//  ChatViewModel.swift
//  PrivySilicon
//
//  Created by Anurag Pandit on 08/07/25.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
    // MARK: - Public
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isThinking: Bool = false
    
    // MARK: - Dependencies
    private let modelContext: ModelContext
    private let llmClient: LLMClient
    
    // MARK: - Init
    init(modelContext: ModelContext, llmClient: LLMClient) {
        self.modelContext = modelContext
        self.llmClient = llmClient
        loadMessages()
    }
    
    // MARK: - Message Handling
    func sendMessage() async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // Append user message
        let userMsg = ChatMessage(role: .user, content: trimmed)
        messages.append(userMsg)
        modelContext.insert(userMsg)
        inputText = ""
        
        // Get response
        isThinking = true
        do {
            let response = try await llmClient.generateResponse(for: messages)
            let assistantMsg = ChatMessage(role: .assistant, content: response)
            messages.append(assistantMsg)
            modelContext.insert(assistantMsg)
        } catch {
            print("LLM Error:", error.localizedDescription)
            let errMsg = ChatMessage(role: .assistant, content: "⚠️ Sorry, an error occurred.")
            messages.append(errMsg)
            modelContext.insert(errMsg)
        }
        isThinking = false
    }
    
    func clearConversation() {
        for msg in messages {
            modelContext.delete(msg)
        }
        messages.removeAll()
    }
    
    // MARK: - Load from Store
    private func loadMessages() {
        let descriptor = FetchDescriptor<ChatMessage>(
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        do {
            messages = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch messages: \(error.localizedDescription)")
        }
    }
}
