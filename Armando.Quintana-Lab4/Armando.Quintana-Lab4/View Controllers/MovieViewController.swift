//
//  MovieViewController.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/7/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UIViewController {
    var selectedMovie: Movie!
    var savedImage: UIImage!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var poster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var averageScore: UILabel!
    @IBOutlet var releasedDate: UILabel!
    @IBOutlet var overView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = selectedMovie.title
        poster.image = savedImage
        averageScore.text = String(selectedMovie.vote_average)
        overView.text = selectedMovie.overview
        releasedDate.text = selectedMovie.release_date ?? "N/A"
        //print(selectedMovie?.poster_path)
    }
    
    @IBAction func didPressAddToFavorites(_ sender: Any) {
       //favoriteMovies.append(selectedMovie)
        let newMovie = Favorites(context: context)
        let score = String(selectedMovie.vote_average)
        newMovie.title = selectedMovie.title
        newMovie.movieDescription = selectedMovie.overview
        newMovie.image =  savedImage.pngData()
        newMovie.date = selectedMovie.release_date ?? "N/A"
        newMovie.score = score
        do{
            try self.context.save()
        }catch{
            
        }
        fetchSavedMovies()
    }
    
    func fetchSavedMovies(){
           do {
            favoriteMovies = try context.fetch(Favorites.fetchRequest())
    
           }
           catch {
               
           }
       }
}
