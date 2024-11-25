//
//  APIManager.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    func fetchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let apiKey = Utilities.getAPIKey(),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&api_key=\(apiKey)&language=en-US&include_adult=false") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "APIError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "APIError", code: 204, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)

                // Date formatter to parse the release date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let currentDate = Date()

                // Filter the movies explicitly to ensure they have release dates in the future
                let filteredMovies = decodedResponse.results.filter { movie in
                    guard let releaseDateString = movie.releaseDate,
                          let releaseDate = dateFormatter.date(from: releaseDateString) else {
                        return false // Exclude movies with invalid or missing release dates
                    }
                    return releaseDate >= currentDate // Include movies with future release dates
                }

                completion(.success(filteredMovies))
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Function to fetch upcoming movies from the API
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let apiKey = Utilities.getAPIKey() else {
                print("Invalid API key")
                completion(.failure(NSError(domain: "APIError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API Key"])))
                return
            }

            // Format dates for the API query
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = Date()
            let minDate = dateFormatter.string(from: currentDate)
            let maxDate = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate)

            // Construct the discover API URL
            guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_release_type=2&release_date.gte=\(minDate)&release_date.lte=\(maxDate)&api_key=\(apiKey)") else {
                print("Invalid URL")
                completion(.failure(NSError(domain: "APIError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            print("Requesting URL: \(url.absoluteString)") // Log the full URL for debugging

            // Perform the network request
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Request failed: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion(.failure(NSError(domain: "APIError", code: 204, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)

                    // Filter the movies explicitly to ensure they have release dates in the future
                    let filteredMovies = decodedResponse.results.filter { movie in
                        guard let releaseDateString = movie.releaseDate,
                              let releaseDate = dateFormatter.date(from: releaseDateString) else {
                            return false // Exclude movies with invalid or missing release dates
                        }
                        return releaseDate >= currentDate // Include movies with future release dates
                    }

                    completion(.success(filteredMovies))
                } catch {
                    print("Failed to decode response: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }.resume()
    }
}
