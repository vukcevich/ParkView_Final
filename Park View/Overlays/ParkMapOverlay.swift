//
//  ParkMapOverlay.swift
//  Park View
//
//  Created by Marijan Vukcevich on 8/30/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation
import MapKit

class ParkMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(park: Park) {
        boundingMapRect = park.overlayBoundingMapRect
        coordinate = park.midCoordinate
    }
}
