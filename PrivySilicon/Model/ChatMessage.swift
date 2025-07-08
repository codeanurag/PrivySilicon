//
//  ChatMessage.swift
//  PrivySilicon
//
//  Created by Anurag Pandit on 08/07/25.
//


import Foundation
import SwiftData

@Model
final class ChatMessage {
    var id: UUID
    var role: Role
    var content: String
    var timestamp: Date
    
    init(id: UUID = UUID(), role: Role, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

extension ChatMessage {
    static var sampleUser: ChatMessage {
        ChatMessage(role: .user, content: "What is the capital of France?")
    }
    
    static var sampleAssistant: ChatMessage {
        ChatMessage(role: .assistant, content: "The capital of France is Paris.")
    }
}
