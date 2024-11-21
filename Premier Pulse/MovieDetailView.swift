//
//  MovieDetailView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Show a loading indicator while the image loads
                                .frame(width: 300, height: 450) // 2 * 3 aspect ratio for posters should divide to 0.667
                        case .success(let image):
                            image.resizable()
                                .frame(width: 300, height: 450)
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo") // Show a placeholder image on failure
                                .resizable()
                                .frame(width: 300, height: 450)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
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
