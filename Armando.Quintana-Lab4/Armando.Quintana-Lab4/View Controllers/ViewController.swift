//
//  ViewController.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/7/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var noResultsLabel: UILabel!
    @IBOutlet var loading: UIActivityIndicatorView!
    var pressedReturn = false
    var searchResultsReturned = false
    var editingSearch = false
    var apiData = [APIResult]()
    var results = [Movie]()
    var fetchMoreMovies = false
    var  pageNum = 1
    var newApiData = [APIResult]()
    var cachedImages = [UIImage]()
    var cachedCustomSearchImages = [UIImage]()
    var customApiData: APIResult?
    var searching = false
    
    override func viewDidLoad() {
        movieCollectionView.isScrollEnabled = true
        super.viewDidLoad()
        loading.startAnimating()
        noResultsLabel.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchMovies()
            self.cachImages()
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=b2eeebbb87c0f5302635138b846412d5")
        let data = try! Data(contentsOf: url!)
        let jsonData = try! JSONDecoder().decode(APIResult.self, from: data)
        apiData.append(jsonData)
        for item in apiData {
            for movie in item.results {
                results.append(movie)
            }
        }
    }
    
    func cachImages(){
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        for item in apiData {
            for movie in item.results {
                if movie.poster_path == nil {
                    let posterURL = URL(string: "https://via.placeholder.com/400x400/000000/FFFFFF/?text=No+Image+found")
                    let data = try? Data(contentsOf: posterURL!)
                    let image = UIImage(data: data!)
                    cachedImages.append(image!)
                }else{
                    guard let posterUrl = movie.poster_path else { return }
                    let fullPosterUrl = URL(string: baseUrl + posterUrl)
                    let data = try? Data(contentsOf: fullPosterUrl!)
                    let image = UIImage(data: data!)
                    cachedImages.append(image!)
                }
            }
        }
    }
    
    func cacheNewImage(movieToAdd: Movie){
        
        if movieToAdd.poster_path == nil {
            let posterURL = URL(string: "https://via.placeholder.com/400x400/000000/FFFFFF/?text=No+Image+found")
            let data = try? Data(contentsOf: posterURL!)
            let image = UIImage(data: data!)
            cachedImages.append(image!)
        }else{
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            guard let posterUrl = movieToAdd.poster_path else { return }
            let fullPosterUrl = URL(string: baseUrl + posterUrl)
            let data = try? Data(contentsOf: fullPosterUrl!)
            let image = UIImage(data: data!)
            cachedImages.append(image!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching == true {
            if customApiData?.results.count != nil {
                searchResultsReturned = true
                return (customApiData?.results.count)!
            }
            else{
                return 0
            }
        }
        
        if results.isEmpty {
            return 0
        }
        searchResultsReturned = false
        loading.stopAnimating()
        loading.isHidden = true
        loading.layer.zPosition = 1
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if searching == true {
            
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
            
            if customApiData?.results.count == 0 {
                return customCell
            }
            
            if customApiData == nil{
                customCell.title.text = results[indexPath.row].title
                customCell.poster!.image = cachedImages[indexPath.row]
            }else{
                customCell.title.text = customApiData!.getMovieTitle(indexPath: indexPath.row)
                customCell.poster!.image = customApiData?.getMoviePoster(indexPath: indexPath.row)
            }
            return customCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        if indexPath.row < cachedImages.count - 1 {
            cell.poster!.image = cachedImages[indexPath.row]
        }
        cell.title.text = results[indexPath.row].title
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offSetY > contentHeight - scrollView.frame.height && searching == false {
            if !fetchMoreMovies {
                pageNum += 1
                newFetchRequest(pageNumber: pageNum)
            }
        }
    }
    
    func newFetchRequest(pageNumber: Int){
        if pageNumber < 500 && searchBar.isFocused == false{
            fetchMoreMovies = true
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/now_playing"
            let apiKey = URLQueryItem(name: "api_key", value: "b2eeebbb87c0f5302635138b846412d5")
            let pageNumber = URLQueryItem(name: "page", value: String(pageNumber))
            components.queryItems = [apiKey, pageNumber]
            let data = try! Data(contentsOf: components.url!)
            let newSearch = try! JSONDecoder().decode(APIResult.self, from: data)
            apiData.append(newSearch)
            loading.startAnimating()
            loading.isHidden = false
            loading.layer.zPosition = 1
            loading.backgroundColor = UIColor(displayP3Red: 119, green: 136, blue: 153, alpha: 0.85)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                for movie in newSearch.results {
                    self.results.append(movie)
                    self.cacheNewImage(movieToAdd: movie)
                }
                self.fetchMoreMovies = false
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchResultsReturned = true
        movieCollectionView.reloadData()
    }
    
    func customSearch(searchText: String){
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/search/movie"
        let apiKey = URLQueryItem(name: "api_key", value: "b2eeebbb87c0f5302635138b846412d5")
        
        let movieSearch = URLQueryItem(name: "query", value: searchText)
        
        if searchText.isEmpty {
            components.queryItems = [apiKey]
            
        }else{
            components.queryItems = [apiKey, movieSearch]
            let data = try! Data(contentsOf: components.url!)
            customApiData = try! JSONDecoder().decode(APIResult.self, from: data)
            
            if customApiData?.results.count == 0 {
                noResultsLabel.isHidden = false
            }else{
                noResultsLabel.isHidden = true
            }
        }
        searchResultsReturned = true
        searching = true
    }
    
    func cacheCustomSearchImages(){
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        for item in customApiData!.results {
            if item.poster_path == nil {
                let posterURL = URL(string: "https://via.placeholder.com/400x400/000000/FFFFFF/?text=No+Image+found")
                let data = try? Data(contentsOf: posterURL!)
                let image = UIImage(data: data!)
                cachedImages.append(image!)
            }else{
                guard let posterUrl = item.poster_path else { return }
                let fullPosterUrl = URL(string: baseUrl + posterUrl)
                let data = try? Data(contentsOf: fullPosterUrl!)
                let image = UIImage(data: data!)
                cachedCustomSearchImages.append(image!)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        pressedReturn = true
        self.searchBar.showsCancelButton = true
        searching = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pressedReturn = true
        searching = true
        self.customSearch(searchText: searchBar.searchTextField.text!)
        searchBar.resignFirstResponder()
        loading.stopAnimating()
        loading.isHidden = true
        loading.layer.zPosition = 1
        DispatchQueue.global(qos: .userInitiated).async{
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        noResultsLabel.isHidden = true
        loading.stopAnimating()
        loading.isHidden = true
        loading.layer.zPosition = 1
        self.movieCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieViewController"{
            
            let cell = sender as! UICollectionViewCell
            let indexPath = movieCollectionView.indexPath(for: cell)?.row
            //  var selectedMovie = apiData[0].getMovie(indexPath: indexPath!)//
            var selectedMovie = results[indexPath!]
            var image = cachedImages[indexPath!]
            
            if searching == true && searchResultsReturned == true{
                selectedMovie = customApiData!.results[indexPath!]
                image = (customApiData?.getMoviePoster(indexPath: indexPath!)!)!
            }
            let view = segue.destination as! MovieViewController
            view.selectedMovie = selectedMovie
            view.savedImage = image
        }
    }
}

