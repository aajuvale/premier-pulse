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
    @State private var showingFavorites = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {
                   

                    // Dynamic sections
                    if query.isEmpty {
                        MovieSection(
                            title: "Upcoming Movies",
                            movies: upcomingMovies,
                            favorites: $favorites,
                            addToFavorites: toggleFavorite
                        )
                    } else {
                        MovieSection(
                            title: "Search Results",
                            movies: results,
                            favorites: $favorites,
                            addToFavorites: toggleFavorite
                        )
                    }

//                    Spacer()
                    // Search bar
                    SearchBar(query: $query, onCommit: { fetchMovies(query: query) })

                    // Favorites button
                    FavoritesButton(favoritesCount: favorites.count) {
                        showingFavorites.toggle()
                    }
                    .sheet(isPresented: $showingFavorites) {
                        FavoritesView(favorites: $favorites)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Optional: Controls the title style
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("PREMIER PULSE")
                        .font(.custom("Optima-Bold", size: 35)) // Apply custom font
                        .foregroundColor(.blue) // Optional: Change text color
                        .padding(.bottom, 10)
                }
            }
            .onAppear { fetchUpcomingMovies() }
        }
    }

    func fetchMovies(query: String) {
        APIManager.shared.fetchMovies(query: query) { fetchedResults in
            DispatchQueue.main.async {
                results = fetchedResults
            }
        }
    }

    func fetchUpcomingMovies() {
        APIManager.shared.fetchUpcomingMovies { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.upcomingMovies = movies // Assign the array of movies
                case .failure(let error):
                    print("Error fetching upcoming movies: \(error.localizedDescription)")
                }
            }
        }
    }

    // Toggle favorite status
    func toggleFavorite(movie: Movie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index) // Remove if already in favorites
        } else {
            favorites.append(movie) // Add if not in favorites
            Utilities.scheduleNotification(for: movie) // Optional: Add notification
        }
    }
    
}



#Preview {
    ContentView()
}
