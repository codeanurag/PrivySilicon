//
//  ContentView.swift
//  PrivySilicon
//
//  Created by Anurag Pandit on 08/07/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            Text("Chat Threads Placeholder")
        } detail: {
            Text("Start a conversation in PrivySilicon.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.05))
        }
    }
}

#Preview {
    ContentView()
}
