//
//  ContentView.swift
//  NetworkMonitor
//
//  Created by YILMAZ ER on 25.05.2023.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isActivate = false
    @Published var isExpensive = false
    @Published var isConstrained = false
    @Published var connectionType = NWInterface.InterfaceType.other
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isActivate = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes: [NWInterface.InterfaceType] = [.cellular, .wifi, .wiredEthernet]
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            }
        }
        monitor.start(queue: queue)
    }
}

struct ContentView: View {
    
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Text(verbatim: "Connection: \(networkMonitor.isActivate)")
                Text(verbatim: "Low Data mode: \(networkMonitor.isConstrained)")
                Text(verbatim: "Mobile Data / Hotspot: \(networkMonitor.isExpensive)")
                Text(verbatim: "Connection: \(networkMonitor.isActivate)")
                Text(verbatim: "Type: \(networkMonitor.connectionType)")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
