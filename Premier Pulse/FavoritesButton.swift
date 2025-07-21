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
            if #available(iOS 26.0, *) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Favorites (\(favoritesCount))")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.tint(.blue.opacity(0.8)).interactive(), in: .rect)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
            } else {
                // Fallback on earlier versions
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
        }
        .padding(.horizontal)
    }
}
