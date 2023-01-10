//
//  EateriesTableViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/21/22.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.separatorColor = .red
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        cell.thumbnailImage.image = UIImage(data: restaurants[indexPath.row].image! as Data) 
        cell.thumbnailImage.layer.cornerRadius = 32.5
        cell.thumbnailImage.clipsToBounds = true
        
        cell.nameLabel.text =  restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        
        cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        
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
                dvc.restaraunt = self.restaurants[indexPath.row]
            }
        }
    }
}
