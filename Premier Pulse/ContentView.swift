//
//  ContentView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/18/24.
//
import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var results: [Movie] = []
    @State private var popularMovies: [Movie] = []
    @State private var favorites: [Movie] = []
    @State private var showingFavorites = false  // State to control the favorites sheet

    var body: some View {
        NavigationView {
            VStack {
                // Search bar to input the movie query
                TextField("Search for a movie...", text: $query, onCommit: {
                    fetchMovies(query: query)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Conditionally display results or popular movies
                if query.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Popular Movies")
                            .font(.headline)
                            .padding(.horizontal)

                        List(popularMovies, id: \.id) { movie in
                            MovieRow(movie: movie, favorites: $favorites)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Fullscreen layout
                } else {
                    List(results, id: \.id) { movie in
                        MovieRow(movie: movie, favorites: $favorites)
                    }
                }

                // Favorites button at the bottom of the screen
                Button(action: {
                    showingFavorites.toggle()
                }) {
                    HStack {
                        Text("Favorites (\(favorites.count))")
                            .font(.title3)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .sheet(isPresented: $showingFavorites) {
                    FavoritesView(favorites: $favorites)
                }
            }
            .navigationTitle("Movie Search")
            .onAppear {
                fetchPopularMovies()
            }
        }
    }

    // Function to fetch search results from the API
    func fetchMovies(query: String) {
        guard let apiKey = getAPIKey(),
              let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(encodedQuery)&api_key=\(apiKey)") else {
            print("Invalid API key or query")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        results = decodedResponse.results
                    }
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Request failed: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    // Function to fetch popular movies from the API
    func fetchPopularMovies() {
        guard let apiKey = getAPIKey(),
              let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") else {
            print("Invalid API key")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        popularMovies = decodedResponse.results
                    }
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Request failed: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    // Function to get the API key from the Secrets.plist
    func getAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = dictionary["TMDB_API_KEY"] as? String else {
            print("API key not found")
            return nil
        }
        return apiKey
    }
}

struct MovieRow: View {
    let movie: Movie
    @Binding var favorites: [Movie]
    @State private var isAnimating = false

    var body: some View {
        HStack(alignment: .top) {
            if let posterPath = movie.posterPath {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { image in
                    image.resizable()
                        .frame(width: 50, height: 75)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)

                if let releaseDate = movie.releaseDate {
                    Text("Release Date: \(releaseDate)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Text("Rating: \(String(format: "%.1f", movie.voteAverage))/10")
                    .font(.subheadline)

                Text(movie.overview)
                    .font(.caption)
                    .lineLimit(3)
            }

            Spacer()

            // Add to or remove from favorites with animation
            Button(action: {
                withAnimation(.spring()) {
                    isAnimating = true
                    if favorites.contains(where: { $0.id == movie.id }) {
                        favorites.removeAll { $0.id == movie.id }
                    } else {
                        favorites.append(movie)
                    }
                }
                // Reset animation state after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isAnimating = false
                }
            }) {
                Image(systemName: favorites.contains(where: { $0.id == movie.id }) ? "bell.fill" : "bell")
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(isAnimating ? 30 : 0)) // Apply rotation effect
            }
        }
    }
}


struct FavoritesView: View {
    @Binding var favorites: [Movie]

    var body: some View {
        NavigationView {
            List(favorites, id: \.id) { movie in
                Text(movie.title)
            }
            .navigationTitle("Favorites")
        }
    }
}



#Preview {
    ContentView()
}
