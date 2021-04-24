//
//  File.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import Foundation
import CoreLocation


struct Coordinate {
    let latitude: Double
    let longitude: Double
    
    init(_ rawValue: CLLocationCoordinate2D) {
        latitude = rawValue.latitude
        longitude = rawValue.longitude
    }
    
    init(_ lat: Double, _ long: Double) {
        self.latitude = lat
        self.longitude = long
    }
}
