//
//  SearchBar.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//


import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    @Environment(\.colorScheme) var colorScheme
    
    var onCommit: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.secondary)
                TextField("Search for a movie...", text: $query, onCommit: onCommit)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .foregroundStyle(Color.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .glassEffect()
            .shadow(radius: 5)
        } else {
            // Fallback on earlier versions
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for a movie...", text: $query, onCommit: onCommit)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.5) : Color.secondary)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}
