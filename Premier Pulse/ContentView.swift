//
//  ContentView.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/18/24.
//
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var query: String = ""
    @State private var results: [Movie] = []
    @State private var upcomingMovies: [Movie] = []
    @State private var favorites: [Movie] = []
    @State private var showingFavorites = false  // State to control the favorites sheet

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else if granted {
                print("Notification permissions granted!")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search bar to input the movie query
                TextField("Search for a movie...", text: $query, onCommit: {
                    fetchMovies(query: query)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Conditionally display results or upcoming movies
                if query.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Upcoming Movies")
                            .font(.headline)
                            .padding(.horizontal)

                        List(upcomingMovies, id: \.id) { movie in
                            MovieRow(
                                movie: movie,
                                favorites: $favorites,
                                addToFavorites: addToFavorites,
                                showRating: false // Hide rating for upcoming movies
                            )
                        }
                        .listStyle(PlainListStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Fullscreen layout
                } else {
                    List(results, id: \.id) { movie in
                        // Wrap logic inside a closure and compute `showRating` dynamically
                        let showRating: Bool = {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let currentDate = Date()
                            if let releaseDate = dateFormatter.date(from: movie.releaseDate ?? "") {
                                return releaseDate <= currentDate // Show rating if the release date is in the past or today
                            }
                            return false // Default to false if release date is invalid
                        }()

                        // Return the MovieRow with the computed `showRating`
                        MovieRow(
                            movie: movie,
                            favorites: $favorites,
                            addToFavorites: addToFavorites,
                            showRating: showRating
                        )
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
                fetchUpcomingMovies()
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

    // Function to fetch upcoming movies from the API
    func fetchUpcomingMovies() {
        guard let apiKey = getAPIKey() else {
            print("Invalid API key")
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
            return
        }

        print("Requesting URL: \(url.absoluteString)") // Log the full URL for debugging

        // Perform the network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
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

                    DispatchQueue.main.async {
                        upcomingMovies = filteredMovies
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

    
    func scheduleNotification(for movie: Movie) {
        guard let releaseDateString = movie.releaseDate,
              let releaseDate = ISO8601DateFormatter().date(from: releaseDateString) else {
            print("Invalid release date for movie: \(movie.title)")
            return
        }

        // Calculate the date two weeks before release
        let twoWeeksBefore = Calendar.current.date(byAdding: .day, value: -14, to: releaseDate)

        // If the movie is already less than two weeks away
        let currentDate = Date()
        let notificationDate: Date
        if let twoWeeksBefore = twoWeeksBefore, twoWeeksBefore > currentDate {
            notificationDate = twoWeeksBefore
        } else {
            // Schedule the notification for the next moment possible
            notificationDate = currentDate.addingTimeInterval(5) // 10 seconds from now
        }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Movie Release"
        content.body = "The movie \"\(movie.title)\" releases on \(releaseDateString). Get ready!"
        content.sound = .default

        // Schedule the notification
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate),
            repeats: false
        )
        let request = UNNotificationRequest(identifier: "\(movie.id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(movie.title) on \(notificationDate).")
            }
        }
    }
    
    func addToFavorites(movie: Movie) {
        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            scheduleNotification(for: movie) // Schedule a notification
        }
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
    var addToFavorites: (Movie) -> Void
    var showRating: Bool // New parameter to toggle the rating display
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

                // Conditionally show the rating
                if showRating {
                    Text("Rating: \(String(format: "%.1f", movie.voteAverage))/10")
                        .font(.subheadline)
                }

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
                        addToFavorites(movie)
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
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Favorites")
        }
    }
}




#Preview {
    ContentView()
}
