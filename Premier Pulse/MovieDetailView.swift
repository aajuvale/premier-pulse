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
    @State private var videos: [Video] = []

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
                                if #available(iOS 26.0, *) {
                                    image.resizable()
                                        .frame(width: 375, height: 565)
                                        .glassEffect(in: .rect)
                                        .cornerRadius(10)
                                } else {
                                    // Fallback on earlier versions
                                    image.resizable()
                                        .frame(width: 375, height: 565)
                                        .cornerRadius(10)
                                }
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
                                        .frame(width: 160, height: 70)
                                        .cornerRadius(10)
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 70)
                                        .cornerRadius(10)
                                        .padding(.leading, 16)
                                case .failure:
                                    Text("No Logo")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
//                        Spacer()
                        Rectangle()
                                .frame(maxWidth: 60) // Acts as a flexible spacer
                                .foregroundColor(.clear) // Make it invisible
                        
                        // Track Release Button
                        Button(action: {
                            toggleFavorites(movie)
                        }) {
                            if #available(iOS 26.0, *) {
                                HStack {
                                    Image(
                                        systemName: favorites
                                            .contains(where: { $0.id == movie.id }) ? "star.fill" : "star"
                                    )
                                    .foregroundColor(favorites.contains(where: { $0.id == movie.id }) ? .yellow : .gray)
                                    Text(
                                        favorites
                                            .contains(where: { $0.id == movie.id }) ? "Remove Alerts" : "Get Alerts!"
                                    )
                                    .font(.body)
                                    .fontWeight(.bold)
                                }
                                .padding()
                                .foregroundColor(.white)
                                .glassEffect(.regular.tint(.blue.opacity(0.8)).interactive(), in: .capsule)
                            } else {
                                // Fallback on earlier versions
                                HStack {
                                    Image(
                                        systemName: favorites
                                            .contains(where: { $0.id == movie.id }) ? "star.fill" : "star"
                                    )
                                    .foregroundColor(favorites.contains(where: { $0.id == movie.id }) ? .yellow : .gray)
                                    Text(
                                        favorites
                                            .contains(where: { $0.id == movie.id }) ? "Remove Alerts" : "Get Alerts!"
                                    )
                                    .font(.body)
                                    .fontWeight(.bold)
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.trailing, 16)
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
                        .frame(maxWidth: UIScreen.main.bounds.width - 40)
                        .font(.body)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        
                   
                    
                    Divider()
                    
                    // Additional Images Section
                    if !additionalImages.isEmpty {
                        Text("Additional Images")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(additionalImages, id: \.self) { imageURL in
                                    AsyncImage(url: imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(10)
                                        case .success(let image):
                                            image.resizable()
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(10)
                                                .scaledToFit()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 150, height: 100)
                                                .cornerRadius(10)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Videos Section
                    if !videos.isEmpty {
                        Text("Videos")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(videos, id: \.id) { video in
                                    Button(action: {
                                        if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(video.key)") {
                                            UIApplication.shared.open(youtubeURL)
                                        }
                                    }) {
                                        VStack {
                                            Image(systemName: "play.rectangle.fill")
                                                .resizable()
                                                .frame(width: 150, height: 100)
                                                .foregroundColor(.red)
                                            Text(video.name)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 150)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear {
            fetchMovieImages()
            fetchVideos()
        }
    }
    
    // Fetch movie images from TMDB API
    func fetchMovieImages() {
        guard let apiKey = Utilities.getAPIKey() else {
            print("Invalid API key")
            return
        }

        // Fetch logos
        if let logoURL = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/images?api_key=\(apiKey)&include_image_language=en") {
            let logoTask = URLSession.shared.dataTask(with: logoURL) { data, response, error in
                if let error = error {
                    print("Failed to fetch logos: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received for logos")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MovieImagesResponse.self, from: data)

                    DispatchQueue.main.async {
                        // Get the first English logo
                        self.logoURL = decodedResponse.logos
                            .first
                            .flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0.filePath)") }
                    }
                } catch {
                    print("Failed to decode logos response: \(error.localizedDescription)")
                }
            }
            logoTask.resume()
        }

        // Fetch additional images (backdrops)
        if let backdropsURL = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/images?api_key=\(apiKey)") {
            let backdropsTask = URLSession.shared.dataTask(with: backdropsURL) { data, response, error in
                if let error = error {
                    print("Failed to fetch additional images: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received for additional images")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MovieImagesResponse.self, from: data)

                    DispatchQueue.main.async {
                        // Fetch backdrops
                        self.additionalImages = decodedResponse.backdrops.map {
                            URL(string: "https://image.tmdb.org/t/p/w500\($0.filePath)")
                        }.compactMap { $0 }
                    }
                } catch {
                    print("Failed to decode additional images response: \(error.localizedDescription)")
                }
            }
            backdropsTask.resume()
        }
    }


    // Fetch videos from TMDB API
    func fetchVideos() {
        guard let apiKey = Utilities.getAPIKey(),
              let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/videos?api_key=\(apiKey)&language=en-US") else {
            print("Invalid API key or URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch videos: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(VideoResponse.self, from: data)

                DispatchQueue.main.async {
                    self.videos = decodedResponse.results
                }
            } catch {
                print("Failed to decode videos response: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

// Models for Videos API Response
struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
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
