//
//  LocationService.swift
//  FoodBookApp
//
//  Created by Juan Diego Yepes Parra on 29/02/24.
//

import Foundation
import CoreLocation

let uniandesLocation = CLLocation(latitude: 4.60136, longitude: -74.06564)

final class LocationService: NSObject, ObservableObject {
    static let shared: LocationService = LocationService()
    @Published var userLocation: CLLocation?
    private let manager = CLLocationManager()
    private var savedRegions = [String: CLCircularRegion]()

    private override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
    }

    func requestLocationAuthorization() {
        setupGeofence(for: uniandesLocation, regionRadius: 240, identifier: "uniandes")
        self.manager.requestWhenInUseAuthorization()
    }
    
    func requestAlwaysLocationAuthorization() {
        self.manager.requestAlwaysAuthorization()
        self.manager.allowsBackgroundLocationUpdates = true
        self.manager.showsBackgroundLocationIndicator = true
    }
    
    func setupGeofence(for location: CLLocation, regionRadius: CLLocationDistance, identifier: String) {
        let geofence = CLCircularRegion(center: location.coordinate, radius: regionRadius, identifier: identifier)
        self.savedRegions[identifier] = geofence
        geofence.notifyOnEntry = true
        self.manager.startUpdatingLocation()
        self.manager.startMonitoring(for: geofence)
        print("created geofence \(identifier)")
    }
    
    func userInRegion(regionId: String) -> Bool {
        return self.savedRegions[regionId]?.contains(self.userLocation?.coordinate ?? CLLocationCoordinate2D()) ?? false
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case.notDetermined:
            print("LOCATION: Not determined")
            self.requestAlwaysLocationAuthorization()
        case.denied:
            print("LOCATION: Denied")
        case.authorizedAlways:
            print("LOCATION: Always authorized")
        case.authorizedWhenInUse:
            print("LOCATION: Authorized when in use")
            self.requestAlwaysLocationAuthorization()
        case.restricted:
            print("LOCATION: Restricted")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
        if Utils.shared.isWithinLunchWindow() && self.userInRegion(regionId: "uniandes") {
            NotificationHandler().sendLunchTimeReminder(identifier: "lunchUniandes")
        }
    }
}
