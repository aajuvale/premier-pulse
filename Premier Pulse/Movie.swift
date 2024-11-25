//
//  Movie.swift
//  Premier Pulse
//
//  Created by Ahmed Juvale on 11/20/24.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let releaseDate: String?
    let overview: String
    let voteAverage: Double
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
    
    var formattedReleaseDate: String? {
            guard let releaseDate = releaseDate else { return nil }

            // Define the input and output date formats
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy"

            // Convert and return the formatted date
            if let date = inputFormatter.date(from: releaseDate) {
                return outputFormatter.string(from: date)
            } else {
                return nil
            }
        }
    
}

struct MovieResponse: Codable {
    let results: [Movie]
}
