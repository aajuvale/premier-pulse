//
//  SearchBar.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//


import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    var onCommit: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for a movie...", text: $query, onCommit: onCommit)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}