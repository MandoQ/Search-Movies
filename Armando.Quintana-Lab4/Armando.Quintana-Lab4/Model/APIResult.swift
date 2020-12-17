//
//  APIResult.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/7/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import Foundation
import UIKit

struct APIResult:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
    
    func getMovieTitle(indexPath: Int) -> String{
        let title = results[indexPath].title
        return title
    }
    
    func getMovie(indexPath: Int) -> Movie {
        let movie = results[indexPath]
        return movie
    }
    
    func getMoviePoster(indexPath: Int) -> UIImage? {
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        let posterUrl = results[indexPath].poster_path
        
        if posterUrl == nil {
            let posterURL = URL(string: "https://via.placeholder.com/300x300/000000/FFFFFF/?text=No+Image+found")
            let data = try? Data(contentsOf: posterURL!)
            let image = UIImage(data: data!)
            return image
        }else{
            let fullPosterUrl = URL(string: baseUrl + posterUrl!)
            let data = try? Data(contentsOf: fullPosterUrl!)
            let image = UIImage(data: data!)
            return image!
        }
        
    
       // cachedCustomSearchImages.append(image!)
    }
}

