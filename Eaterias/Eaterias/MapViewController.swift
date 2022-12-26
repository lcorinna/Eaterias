//
//  MapViewController.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/26/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var restaurant: Restaurant!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let goecoder = CLGeocoder()
        goecoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            guard error == nil else { return }
            guard let tags = placemarks else { return }
            let  marks = tags.first!
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = marks.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        rightImage.image = UIImage(named: restaurant.image)
        annotationView?.rightCalloutAccessoryView = rightImage
        
        annotationView?.pinTintColor = .green
        
        return annotationView
    }
}
