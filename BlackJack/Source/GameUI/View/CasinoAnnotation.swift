//
//  CasinoAnnotation.swift
//  BlackJack
//
//  Created by Bingwen Fu on 4/22/16.
//  Copyright © 2016 Bingwen Fu. All rights reserved.
//

import MapKit
import CoreLocation

class CasinoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}