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
}

struct MovieResponse: Codable {
    let results: [Movie]
}
