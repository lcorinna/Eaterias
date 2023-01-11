//
//  ContentViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 1/11/23.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            dismiss(animated: true)
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = .blue
        pageButton.layer.borderColor = UIColor.white.cgColor
        
        switch index {
        case 0: pageButton.setTitle("Дальше", for: .normal)
        case 1: pageButton.setTitle("Открыть", for: .normal)
        default: break
        }
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
        
    }
    
    
    
}
