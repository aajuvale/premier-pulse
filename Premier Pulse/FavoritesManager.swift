//
//  FavoritesManager.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/25/24.
//


import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "favoriteMovies"

    private init() {}

    // Save favorites to UserDefaults
    func saveFavorites(_ favorites: [Movie]) {
        if let encodedData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        }
    }

    // Load favorites from UserDefaults
    func loadFavorites() -> [Movie] {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey),
           let decodedFavorites = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decodedFavorites
        }
        return []
    }
}
