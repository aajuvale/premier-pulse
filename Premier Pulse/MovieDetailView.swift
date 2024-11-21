//
//  MovieDetailView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @Binding var favorites: [Movie] // Bind to the favorites list
    var toggleFavorites: (Movie) -> Void // Function to toggle favorites

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 300, height: 450) // 2 * 3 aspect ratio
                        case .success(let image):
                            image.resizable()
                                .frame(width: 300, height: 450)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 300, height: 450)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                // Favorites button
                Button(action: {
                    toggleFavorites(movie)
                }) {
                    HStack {
                        Image(systemName: favorites.contains(where: { $0.id == movie.id }) ? "star.fill" : "star")
                            .foregroundColor(favorites.contains(where: { $0.id == movie.id }) ? .yellow : .gray)
                        Text(favorites.contains(where: { $0.id == movie.id }) ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                Text(movie.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)

                if let releaseDate = movie.releaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                Text(movie.overview)
                    .font(.body)
                    .padding(.horizontal)

               
            }
            .padding()
        }
        .navigationTitle(movie.title)
    }
}
