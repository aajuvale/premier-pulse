//
//  MovieDetailView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @Binding var favorites: [Movie]
    var toggleFavorites: (Movie) -> Void
    
    @State private var logoURL: URL?
    @State private var additionalImages: [URL] = []
    
    var body: some View {
        ZStack {
            // Poster as Background
            if let posterPath = movie.posterPath {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                    switch phase {
                    case .empty:
                        Color.black.edgesIgnoringSafeArea(.all)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .blur(radius: 20)
                    case .failure:
                        Color.black.edgesIgnoringSafeArea(.all)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            // Foreground Content
            ScrollView {
                VStack(spacing: 20) {
                    // Movie Poster
                    if let posterPath = movie.posterPath {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 375, height: 565)
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
                    
                    // Logo and Track Release Button Row
                    HStack {
                        // Movie Logo
                        if let logoURL = logoURL {
                            AsyncImage(url: logoURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 120, height: 60)
                                        .cornerRadius(10)
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 60) // Slightly larger
                                        .cornerRadius(10)
                                        .padding(.leading, 16) // Add padding from the left
                                case .failure:
                                    Text("No Logo")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Track Release Button
                        Button(action: {
                            toggleFavorites(movie)
                        }) {
                            HStack {
                                Image(systemName: favorites.contains(where: { $0.id == movie.id }) ? "star.fill" : "star")
                                    .foregroundColor(favorites.contains(where: { $0.id == movie.id }) ? .yellow : .gray)
                                Text(favorites.contains(where: { $0.id == movie.id }) ? "Untrack" : "Track Release!")
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.trailing, 16) // Add padding from the right
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    
                    // Release Date
                    if let releaseDate = movie.formattedReleaseDate {
                        Text("Release Date: \(releaseDate)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    Divider()
                    
                    // Movie Overview
                    Text(movie.overview)
                        .font(.body)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .padding()
            }
        }
        .navigationTitle(movie.title)
        .onAppear {
            fetchMovieImages()
        }
    }
    
    // Fetch movie images from TMDB API
    func fetchMovieImages() {
        guard let apiKey = Utilities.getAPIKey(),
              let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/images?api_key=\(apiKey)&include_image_language=en") else {
            print("Invalid API key or URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch images: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Debug: Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MovieImagesResponse.self, from: data)

                DispatchQueue.main.async {
                    // Use the first logo (should already be filtered by the query parameter)
                    self.logoURL = decodedResponse.logos
                        .first
                        .flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0.filePath)") }

                    // Map additional images
                    self.additionalImages = decodedResponse.backdrops.map {
                        URL(string: "https://image.tmdb.org/t/p/w500\($0.filePath)")
                    }.compactMap { $0 }
                }
            } catch {
                print("Failed to decode images response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }



    
}

// Models for Movie Images API Response
struct MovieImagesResponse: Codable {
    let backdrops: [MovieImage]
    let logos: [MovieImage]

    enum CodingKeys: String, CodingKey {
        case backdrops
        case logos = "logos"
    }
}

struct MovieImage: Codable {
    let filePath: String
    let language: String? // Corresponds to "iso_639_1"

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case language = "iso_639_1"
    }
}
