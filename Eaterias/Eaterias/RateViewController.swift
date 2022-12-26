//
//  RateViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/26/22.
//

import UIKit

class RateViewController: UIViewController {
    
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    
    var restRating: String?
    
    @IBAction func rateRestaurant(sender: UIButton) {
        switch sender.tag {
        case 0:
            restRating = "bad"
        case 1:
            restRating = "goob"
        case 2:
            restRating = "brilliant"
        default:
            break
        }
        
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        UIView.animate(withDuration: 0.4) {
        //        self.ratingStackView.transform = CGAffineTransform(scaleX: 1, y: 1)
        //        }
        
        let buttonArray = [badButton, goodButton, brilliantButton]
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: { button?.transform = CGAffineTransform(scaleX: 1, y: 1) }, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        blurEffect()
    }
    
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 1)
    }
    
    
}
