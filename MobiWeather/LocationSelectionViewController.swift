//
//  LocationSelectionViewController.swift
//  MobiWeather
//
//  Created by Adwitech on 07/05/21.
//  Copyright © 2021 techvedika. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationSelectionViewController: UIViewController {

    @IBOutlet weak var cityMapView: MKMapView!
    let currentPin = MKPointAnnotation()
    var currentLocation: LocationInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDeviceLocation()
        // Do any additional setup after loading the view.
        
    }
    
    func getDeviceLocation() {
        MBLocationManager.shared.start { (info) in
//            print(info.longitude ?? 0.0)
//            print(info.latitude ?? 0.0)
//            print(info.address ?? "")
//            print(info.city ?? "")
//            print(info.zip ?? "")
            self.currentLocation = info
            let center = CLLocationCoordinate2D(latitude: info.latitude ?? 0.0, longitude: info.longitude ?? 0.0)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.cityMapView.setRegion(region, animated: true)
            
            self.currentPin.title = info.city ?? ""
            self.currentPin.coordinate = center
            self.currentPin.coordinate = self.cityMapView.region.center
            self.cityMapView.addAnnotation(self.currentPin)
        }
    }
    
    @IBAction func bookmarkAction(_ sender: Any) {
        if let location = currentLocation {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
            let newLocation = NSManagedObject(entity: entity!, insertInto: context)
            
            newLocation.setValue(location.latitude ?? 0.0, forKey: "latitude")
            newLocation.setValue(location.longitude ?? 0.0, forKey: "longitude")
            newLocation.setValue(location.address, forKey: "address")
            newLocation.setValue(location.city, forKey: "city")
            
            do {
                try context.save()
                self.showAlert("Suceessfully bookmarked the location")
                self.dismiss(animated: true, completion: nil)
            } catch {
                
                print("Failed saving")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationSelectionViewController: MKMapViewDelegate {

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        currentPin.coordinate = cityMapView.region.center
        let location = CLLocation(latitude: currentPin.coordinate.latitude, longitude: currentPin.coordinate.longitude)
        MBLocationManager.shared.reverseGeoCoder(location)
    }

}
