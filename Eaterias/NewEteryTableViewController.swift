//
//  NewEteryTableViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/28/22.
//

import UIKit

class NewEteryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var isVisited = false
    
    @IBAction func toggleIsVisitedPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = .orange
            noButton.backgroundColor = .gray
            isVisited = true
        } else if sender == noButton {
            sender.backgroundColor = .orange
            yesButton.backgroundColor = .gray
            isVisited = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || adressTextField.text == "" || typeTextField.text == "" {
            
            let emptyFields = UIAlertController(title: "Вы заполнили не все поля", message: nil, preferredStyle: .actionSheet)
            let keepFilling = UIAlertAction(title: "Продолжить заполнение", style: .default)
            
            emptyFields.addAction(keepFilling)
            self.present(emptyFields, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let restaurant = Restaurant(context: context)
                restaurant.name = nameTextField.text
                restaurant.location = adressTextField.text
                restaurant.type = typeTextField.text
                restaurant.isVisited = isVisited
                
                if let image = imageView.image {
                    restaurant.image = image.pngData()
                }
                do {
                    try context.save()
                    print("Сохранение удалось")
                } catch let error as NSError {
                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                }
            }
            performSegue(withIdentifier: "unwindSegueFromNewEatery", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: NSLocalizedString("Выберите источник", comment: "Выберите источник"), message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера"), style: .default, handler: { (action) in self.chooseImagePickerAction(source: .camera) })
            let photoAction = UIAlertAction(title: NSLocalizedString("Фото", comment: "Фото"), style: .default, handler: { (action) in self.chooseImagePickerAction(source: .photoLibrary) })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .default)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
