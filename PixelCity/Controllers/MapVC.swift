//
//  MapVC.swift
//  PixelCity
//
//  Created by Saurabh Dixit on 5/19/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapVC: UIViewController {
    
    //instance of coreLocation
    // var locationManager = CLLocationManager()
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    // let regionRadius: Double = 1000
    
    //let location: CLLocation
    let regionRadius: CLLocationDistance = 1000
    let initialLocation = CLLocation(latitude: 19.0760908, longitude: 72.877426)
    
    //outlets
    
    @IBOutlet weak var MapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        print(locationManager)
    }
    
    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
            print("center button pressed")
        }
        else{
            //centerMapOnUserLocation()
            print("inside else")
        }
    }
    
}
extension MapVC: MKMapViewDelegate{
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else {
            print(locationManager.location)
            return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    
}
extension MapVC: CLLocationManagerDelegate {
    //function we created on our own
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            print("authorization is not determined")
        }
        else {
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
        
    }
    
}


