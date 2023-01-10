//
//  EateryDetailViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/23/22.
//

import UIKit

class EateryDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var mapButoon: UIButton!
    
    var restaraunt: Restaurant?
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? RateViewController else { return }
        guard let rating = svc.restRating else { return }
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonsWithFrame = [rateButton, mapButoon]
        for button in buttonsWithFrame {
            button?.layer.cornerRadius = 5
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.white.cgColor
        }
        
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableView.automaticDimension
        
        imageView.image = UIImage(data: restaraunt!.image! as Data)
        
        tableView.separatorColor = .red
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        title = restaraunt!.name
    }
    
}
 
extension EateryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateryDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.keyLabel.text = "Название"
            cell.valueLabel.text = restaraunt!.name
        case 1:
            cell.keyLabel.text = "Тип"
            cell.valueLabel.text = restaraunt!.type
        case 2:
            cell.keyLabel.text = "Адрес"
            cell.valueLabel.text = restaraunt!.location
        case 3:
            cell.keyLabel.text = "Я там был"
            cell.valueLabel.text = restaraunt!.isVisited ? "Да" : "Нет"
        default:
            break
        }
        
        cell.backgroundColor = .orange
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! MapViewController
            dvc.restaurant = self.restaraunt 
        }
            
    }
}
