//
//  Movie.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/7/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count: Int!
}

//var favoriteMovies: [Movie] = []
var favoriteMovies: [Favorites] = []
//var savedFavorites:[Favorites]?
