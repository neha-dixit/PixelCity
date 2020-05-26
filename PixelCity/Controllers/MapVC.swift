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



class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    //instance of coreLocation
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    // let regionRadius: Double = 1000
    let regionRadius: CLLocationDistance = 1000
    var spinner = UIActivityIndicatorView()
    var progressLbl: UILabel!
    var screenSize = UIScreen.main.bounds
    
    //outlets
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var MapViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pullUPVIEw: UIView!
    @IBOutlet weak var MapviewHeightConstaint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
        print(locationManager)
    }
    
    func addDoubleTap(){
        let doubltTap = UITapGestureRecognizer(target: self, action: #selector(dropPin))
        doubltTap.numberOfTapsRequired = 2
        doubltTap.delegate = self
        MapView.addGestureRecognizer(doubltTap)
    }
    func addSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUPVIEw.addGestureRecognizer(swipe)
    }
    //function for pullupview layout
    
    func animateViewUP(){
        MapviewHeightConstaint.constant = 300
        // now we need to call a layout
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
            
        }
    }
    @objc func animateViewDown(){
        MapviewHeightConstaint.constant = 0
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner.center = CGPoint(x: (screenSize.width/2) - (spinner.frame.width)/2 , y: 150)
        spinner.style = .whiteLarge
        spinner.color = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        spinner.startAnimating()
        pullUPVIEw.addSubview(spinner)
        
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
    //chhange userlocation pin to normal one
    //  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    //  }
    // }
    
    //change color of our drop pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return pinAnnotation
    }
    
    
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else {
            print(locationManager.location)
            return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    @objc func dropPin(sender: UITapGestureRecognizer){
        removePin()
        animateViewUP()
        addSwipe()
        addSpinner()
        //drop the pin here
        let touchPoint = sender.location(in: MapView)
        
        let touchCoordinate = MapView.convert(touchPoint, toCoordinateFrom: MapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        MapView.addAnnotation(annotation)
        //to center the pin
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    //remove existing Pins
    func removePin(){
        for annotation in MapView.annotations {
            MapView.removeAnnotation(annotation)
        }
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


