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
    
    var restaraunt: Restaurant?
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rateButton.layer.cornerRadius = 5
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.white.cgColor
        
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableView.automaticDimension
        
        imageView.image = UIImage(named: restaraunt!.image)
        
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
}
