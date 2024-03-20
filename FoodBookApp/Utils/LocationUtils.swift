//
//  LocationUtils.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 20/03/24.
//

import Foundation
import CoreLocation

final class LocationUtils {
    func calculateDistance(fromLatitude: Double, fromLongitude: Double, toLatitude: Double, toLongitude: Double) -> String {
//        print("DEBUG: Calculating distance from \(fromLatitude), \(fromLongitude) to \(toLatitude), \(toLongitude)")
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: fromLatitude, longitude: fromLongitude)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: toLatitude, longitude: toLongitude)
        
        let sourceLocation = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        let destinationLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        let distanceInKilometers = sourceLocation.distance(from: destinationLocation)/1000
//        print("DEBUG: Got this distance \(distanceInKilometers) ")
        
        if distanceInKilometers > 99 {
//            print("DEBUG: Returned +99 since distance is too long")
            return "+99"
        } else {
            // Formatting the distance as a string with two decimal places and "km" appended
            let formattedDistance = String(format: "%.2f", distanceInKilometers)
            return formattedDistance
        }
    }
}
