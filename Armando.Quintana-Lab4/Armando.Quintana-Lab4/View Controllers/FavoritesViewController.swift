//
//  FavoritesViewController.swift
//  Armando.Quintana-Lab4
//
//  Created by Mando Quintana on 11/8/20.
//  Copyright © 2020 Armando Quintana. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //https://www.youtube.com/watch?v=gWurhFqTsPU&list=RDCMUC2D6eRvCeMtcF5OGHf1-trw&index=2&ab_channel=CodeWithChris These sets of videos helped me understand and learn how to implement core data 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet var sortButton: UIBarButtonItem!
    @IBOutlet var favoritesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedMovies()
    }
    
    func fetchSavedMovies(){
        do {
            favoriteMovies = try context.fetch(Favorites.fetchRequest())
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteMovies.count == 0 {
            return 0
        }
        
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.title.text = favoriteMovies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let movieToRemove = favoriteMovies[indexPath.row]
            self.context.delete(movieToRemove)
            try! self.context.save()
          //  favoriteMovies.remove(at: indexPath.row)
            self.fetchSavedMovies()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        favoriteMovies.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

         // MARK: - Navigation
         // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsViewController" {
            let cell = sender as! UITableViewCell
            let indexPath = favoritesTableView.indexPath(for: cell)?.row
            let selectedMovie = favoriteMovies[indexPath!]
            let view = segue.destination as! MovieDetailsViewController
            view.selectedMovie = selectedMovie
        }
    }
         
    @IBAction func deleteAllFavorites(_ sender: Any) {
        for movie in favoriteMovies {
            context.delete(movie)
            try! context.save()
        }
        
         fetchSavedMovies()
          print(favoriteMovies)
        favoritesTableView.reloadData()
    }
    
    @IBAction func sortTableView(_ sender: Any) {
        //https://www.youtube.com/watch?v=GUnzTIYSucU&ab_channel=iOSAcademy. This taught me how to rearrange the table view cells
        if favoritesTableView.isEditing == true {
            favoritesTableView.isEditing = false
            sortButton.title = "Sort"
            
        }else{
            favoritesTableView.isEditing = true
            sortButton.title = "Done"
        }
    }
}
