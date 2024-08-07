//
//  EcoflowDataResponse.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 29.07.2024.
//

import Foundation

public struct EcoflowDataResponse {
    public var timestamp: Date
    public var device: String
    public var moduleType: String
    public var params: [String:Parameter]
    
    public enum Parameter {
        case int(Int)
        case double(Double)
        case string(String)
        case other(String)
    }
    
    public init(timestamp: Date, device: String, moduleType: String, params: [String:EcoflowDataResponse.Parameter]) {
        self.timestamp = timestamp
        self.device = device
        self.moduleType = moduleType
        self.params = params
    }
}
