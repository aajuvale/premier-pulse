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
                                .frame(width: 375, height: 565) // 2 * 3 aspect ratio
                                .cornerRadius(10)
                        case .success(let image):
                            image.resizable()
                                .frame(width: 375, height: 565)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 375, height: 565)
                                .cornerRadius(10)
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
                    .frame(maxWidth: 300)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

//                Text(movie.title)
//                    .font(.largeTitle)
//                    .multilineTextAlignment(.center)

                if let releaseDate = movie.releaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
//                Text("Synopsis")
//                    .font(.title2)
//                    .bold()
//                    .frame(maxWidth: .infinity)
                
                Divider()
                
                Text(movie.overview)
                    .font(.body)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

               
            }
            .padding()
        }
        .navigationTitle(movie.title)
    }
}
