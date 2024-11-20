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

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for a movie...", text: $query, onCommit: {
                    fetchMovies(query: query)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

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
                    }
                }
            }
            .navigationTitle("Movie Search")
        }
    }

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

#Preview {
    ContentView()
}
