//
//  ViewController.swift
//  ZaHunter
//
//  Created by Christian Carnalla on 5/14/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    var currentLocation:CLLocation!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var pizza: [MKMapItem] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
       
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    @IBAction func whenZoomButtonPressed(_ sender: Any) {
        let center = currentLocation.coordinate
                
                let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)

        let region = MKCoordinateRegion(center: center, span: span)
                mapView.setRegion(region, animated: true)
                
    
    
    
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]

}

  
    @IBAction func whenSearchButtonPressed(_ sender: Any) {
    
    let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
       
       
    
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response{
           
            for currentMapItem in response.mapItems {
              
                self.pizza.append(currentMapItem)
                print(response)
              
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = currentMapItem.placemark.coordinate
                
                annotation.title = currentMapItem.name
                self.mapView.addAnnotation(annotation)
                
            }
        }

    
    }


        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        return pin
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        var currentMapItem = MKMapItem()
        if let coordinate = view.annotation?.coordinate {
            for mapItem in pizza {
                if mapItem.placemark.coordinate.latitude == coordinate.latitude && mapItem.placemark.coordinate.longitude == coordinate.longitude {
                    currentMapItem = mapItem
            }
        }
        }
     
        
        
    
    }
}
}
