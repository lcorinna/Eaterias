//
//  EateriesTableViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/21/22.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    //        Restaurant(name: "pushok", type: "eatery", location: "Tokyo", image: "pushok.jpg", isVisited: false),
    //        Restaurant(name: "cookies", type: "restaurant", location: "Oman", image: "cookies.jpg", isVisited: false),
    //        Restaurant(name: "flowers", type: "cafe", location: "Rotterdam", image: "flowers.jpg", isVisited: false),
    //        Restaurant(name: "funny cat", type: "fast food", location: "Tahiti", image: "funny cat.jpg", isVisited: false),
    //        Restaurant(name: "donuts", type: "restaurant", location: "Miami", image: "donuts.jpg", isVisited: false),
    //        Restaurant(name: "Assol put?", type: "fast food", location: "Anapa", image: "Assol put?.jpg", isVisited: false),
    //        Restaurant(name: "space", type: "cafe", location: "Pretoria", image: "space.jpg", isVisited: false),
    //        Restaurant(name: "bitch beach", type: "restaurant", location: "Volgograd", image: "bitch beach.jpg", isVisited: false),
    //        Restaurant(name: "hot dogs", type: "fast food", location: "Berlin", image: "hot dogs.jpg", isVisited: false),
    //        Restaurant(name: "insides", type: "eatery", location: "Vatican", image: "insides.jpg", isVisited: false),
    //        Restaurant(name: "horse meat (halal)", type: "eatery", location: "Moscow", image: "horse meat (halal)", isVisited: false)]
    
    // site with image https://bipbap.ru/pictures/kartinki-500x500-foto.html
    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter { (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self //т.к. подписалить на протокол UISearchResultsUpdating
        searchController.searchBar.barTintColor = .green
        searchController.searchBar.tintColor = .red
        definesPresentationContext = true //убираем поле поиска при переходе в инфо
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.separatorColor = .red
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            pageVC.modalPresentationStyle = .fullScreen
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch results
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = newIndexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = newIndexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return restaurants.count
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailImage.image = UIImage(data: restaurant.image! as Data)
        cell.thumbnailImage.layer.cornerRadius = 32.5
        cell.thumbnailImage.clipsToBounds = true
        
        cell.nameLabel.text =  restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let ac = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
    //
    //        let call = UIAlertAction(title: "Позвонить +7(800)555-35-3\(indexPath.row)", style: .default) {
    //            (action: UIAlertAction) -> Void in
    //
    //            let alertC = UIAlertController(title: nil, message:  "Вызов не может быть совершен", preferredStyle: .alert)
    //            let ok = UIAlertAction(title: "Ок", style: .default, handler: nil)
    //            alertC.addAction(ok)
    //            self.present(alertC, animated: true, completion: nil)
    //        }
    //
    //        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "Я не был здесь" : "Я был здесь"
    //
    //        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) { (action) in
    //            let cell = tableView.cellForRow(at: indexPath)
    //            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
    //            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
    //        }
    //
    //        let cancel = UIAlertAction(title: "Назад", style: .cancel, handler: nil)
    //        ac.addAction(cancel)
    //        ac.addAction(isVisited)
    //        ac.addAction(call)
    //        present(ac, animated: true, completion: nil)
    //
    //        tableView.deselectRow(at: indexPath, animated: true )
    //    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            self.restaurantNames.remove(at: indexPath.row)
    //            self.restaurantImage.remove(at: indexPath.row)
    //            self.restaurantIsVisited.remove(at: indexPath.row)
    //        }
    ////        tableView.reloadData()
    //        tableView.deleteRows(at: [indexPath], with: .fade)
    //    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let share = UIContextualAction(style: .destructive, title: "Поделиться") {  (contextualAction, view, boolValue) in
            let defaulText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaulText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        let delete = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        share.backgroundColor = .purple
        delete.backgroundColor = .black
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, share])
        
        return swipeActions
    }
    
    //устаревшая функция редактирования действий
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
    //            let defaulText = "Я сейчас в " + self.restaurantImage[indexPath.row]
    //            if let image = UIImage(named: self.restaurantNames[indexPath.row]) {
    //                let activityController = UIActivityViewController(activityItems: [defaulText, image], applicationActivities: nil)
    //                self.present(activityController, animated: true, completion: nil)
    //            }
    //        }
    //
    //        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
    //            self.restaurantNames.remove(at: indexPath.row)
    //            self.restaurantImage.remove(at: indexPath.row)
    //            self.restaurantIsVisited.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //
    //        share.backgroundColor = .purple
    //        return [delete, share]
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDetailViewController
                dvc.restaraunt = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
}

extension EateriesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
