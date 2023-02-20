//
//  Movie.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation

enum Genre {
    
}

struct Movie: Codable, Identifiable {
    let id: Int?
    let posterPath: String?
    let isAdult: Bool?
    let overview: String?
    let releaseDate: String?
    let genres: [Int]?
    let title: String?
    let popularity: Double?
    let voteCount: Int?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case isAdult
        case overview
        case releaseDate = "release_date"
        case genres
        case title
        case popularity
        case voteCount = "vote_count"
        case voteAverage
    }
}
