//
//  LocationService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 29/02/24.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, ObservableObject {
    static let shared: LocationService = LocationService()
    @Published var userLocation: CLLocation?
    private let manager = CLLocationManager()

    private override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
    }

    func requestLocationAuthorization() {
        self.manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case.notDetermined:
            print("LOCATION: Not determined")
        case.denied:
            print("LOCATION: Denied")
        case.authorizedAlways:
            print("LOCATION: Always authorized")
        case.authorizedWhenInUse:
            print("LOCATION: Authorized when in use")
        case.restricted:
            print("LOCATION: Restricted")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.userLocation = location
    }
    
    
}
