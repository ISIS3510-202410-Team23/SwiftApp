//
//  NetworkService.swift
//  FoodBookApp
//
//  Created by Maria Castro on 4/11/24.
//

import Foundation
import Network

//@Observable
class NetworkService: ObservableObject {
    
    static let shared = NetworkService()
    
    @Published var isOnline = true
    @Published var isLowConnection = false
    @Published var isUnavailable = false
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    public private(set) var networkStatus: NWPath.Status = .requiresConnection // TODO: review if this is needed
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isOnline = path.status == .satisfied
                self.isLowConnection = path.isConstrained // Activated when 'Low Data Mode' is active on the device's Cellular Data Options
                self.isUnavailable = path.status == .unsatisfied || path.status == .requiresConnection
                
                print("Change in the network, new values follow:")
                print("Status: \(path.status)") // satisfied, unsatisfied, requiresConnection
                print("isExpensive: \(path.isExpensive)")
                print("isOnline: \(self.isOnline)")
                print("isLowConn / isConstrained: \(self.isLowConnection)") // isContrained == true
                print("isUnavailble: \(self.isUnavailable)") //
            }
        }
        monitor.start(queue: queue)
    }
    
    func checkStatus () {
        let path = self.monitor.currentPath
        print("Network Status Report")
        print("Change in the network, new values follow:")
        print("Status: \(path.status)") // satisfied, unsatisfied, requiresConnection
        print("isExpensive: \(path.isExpensive)")
        print("isOnline: \(self.isOnline)")
        print("isLowConn / isConstrained: \(self.isLowConnection)") // isContrained == true
        print("isUnavailble: \(self.isUnavailable)") //
    }
    
}
