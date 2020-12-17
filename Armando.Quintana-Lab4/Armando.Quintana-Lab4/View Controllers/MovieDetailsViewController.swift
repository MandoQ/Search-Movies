//
//  MovieDetailsViewController.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/8/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var selectedMovie: Favorites?
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var overview: UILabel!
    @IBOutlet var poster: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = selectedMovie?.title
        overview.text = selectedMovie?.movieDescription
        poster.image = UIImage(data: (selectedMovie?.image)!)
        date.text = selectedMovie!.date ?? "NA"
        score.text = (selectedMovie?.score ?? "NA") 
    }
}
