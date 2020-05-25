//
//  DroppablePin.swift
//  PixelCity
//
//  Created by Saurabh Dixit on 5/25/20.
//  Copyright © 2020 Dixit. All rights reserved.
//

import UIKit
import MapKit
class DroppablePin:  NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    
    //dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
        
    }
    
    
}
