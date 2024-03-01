//
//  LocationService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 29/02/24.
//

import Foundation
import CoreLocation

final class LocationService: NSObject { //TODO: check how this is working
    static let shared: LocationService = LocationService()
    private let manager = CLLocationManager()

    private override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            let status = self.manager.authorizationStatus
            handleAuthorizationStatus(status)
        } else {
            print("Location services are not enabled.")
        }
    }

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location services denied or restricted.")
        default:
            break
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle the updated location
        guard let location = locations.last else { return }
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        handleAuthorizationStatus(status)
    }
}
