//
//  MovieCard.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//


import SwiftUI

struct MovieCard: View {
    let movie: Movie
    @Binding var favorites: [Movie]
    var addToFavorites: (Movie) -> Void

    var body: some View {
        HStack(alignment: .top) {
            if let posterPath = movie.posterPath {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { image in
                    image.resizable()
                        .frame(width: 70, height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 70, height: 100)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)

                if let releaseDate = movie.formattedReleaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Text(movie.overview)
                    .font(.caption)
                    .lineLimit(3)
            }

            Spacer()

            Button(action: { addToFavorites(movie) }) {
                Image(systemName: favorites.contains(where: { $0.id == movie.id }) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
