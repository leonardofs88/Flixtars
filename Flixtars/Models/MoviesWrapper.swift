//
//  MoviesWrapper.swift
//  Flixtars
//
//  Created by Leonardo Soares on 19/02/23.
//

import Foundation

struct MoviesWrapper: Codable {
    let page: Int?
    let results: [Movie]?
}
