//
//  MovieSection.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//


import SwiftUI

struct MovieSection: View {
    let title: String
    let movies: [Movie]
    @Binding var favorites: [Movie]
    var addToFavorites: (Movie) -> Void
//    var toggleFavorites: (Movie) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .bold(true)
                .padding(.horizontal)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(movies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie, favorites: $favorites, toggleFavorites: addToFavorites)) {
                            MovieCard(movie: movie, favorites: $favorites, addToFavorites: addToFavorites)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 2.5)
                    }
                }
            }
        }
    }
}
