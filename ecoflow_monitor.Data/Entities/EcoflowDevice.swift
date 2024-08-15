//
//  EcoflowDevice.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation

public struct EcoflowDevice: Identifiable {
    public var id: String { deviceSN }
    
    public var deviceSN: String
    public var deviceName: String
    public var isShared: Bool
    
    public init(deviceSN: String, deviceName: String, isShared: Bool = false) {
        self.deviceSN = deviceSN
        self.deviceName = deviceName
        self.isShared = isShared
    }
}
