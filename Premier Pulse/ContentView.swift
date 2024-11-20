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

                // List to display the search results
                List(results, id: \.id) { movie in
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
                                .lineLimit(3) // Limit the number of lines for readability
                        }

                        // Add or remove movie from favorites
                        Button(action: {
                            if favorites.contains(where: { $0.id == movie.id }) {
                                removeFromFavorites(movie: movie)
                            } else {
                                addToFavorites(movie: movie)
                            }
                        }) {
                            Text(favorites.contains(where: { $0.id == movie.id }) ? "Remove" : "Add to Favorites")
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Favorites button at the bottom of the screen
                Spacer()
                
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
                    // Sheet view displaying the list of favorite movies
                    FavoritesView(favorites: $favorites)
                }
            }
            .navigationTitle("Movie Search")
        }
    }

    // Function to fetch movies from the API
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

    // Function to add a movie to favorites
    func addToFavorites(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
        }
    }

    // Function to remove a movie from favorites
    func removeFromFavorites(movie: Movie) {
        favorites.removeAll { $0.id == movie.id }
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
