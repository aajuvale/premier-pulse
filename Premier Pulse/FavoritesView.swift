//
//  FavoritesView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var favorites: [Movie]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(favorites, id: \.id) { movie in
                        MovieCard(movie: movie, favorites: $favorites, addToFavorites: { _ in })
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
        }
    }
}
