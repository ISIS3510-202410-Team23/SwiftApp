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
    public private(set) var networkStatus: NWPath.Status = .requiresConnection // TODO: review if this is needed
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            let queue = DispatchQueue.main
            queue.sync {
                self.isOnline = path.status == .satisfied
                self.isLowConnection = path.isConstrained // Haven't been able to test for this conditions
                self.isUnavailable = path.status == .unsatisfied || path.status == .requiresConnection
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor") // TODO: this might be a multithreading strategy
        monitor.start(queue: queue)
    }
    
    func checkStatus () {
        let path = self.monitor.currentPath
        print(path.status) // satisfied, unsatisfied, requiresConnection
        print(path.isExpensive)
        print(path.isConstrained)
        print(self.isOnline)
        print(self.isLowConnection)
        print(self.isUnavailable)
        
    }
    
}
