//
//  FavoritesButton.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//


import SwiftUI

struct FavoritesButton: View {
    let favoritesCount: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Favorites (\(favoritesCount))")
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}
