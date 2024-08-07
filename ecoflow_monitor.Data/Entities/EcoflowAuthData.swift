//
//  EcoflowAuthData.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 23.07.2024.
//

import Foundation

public struct EcoflowAuthData {
    public init(token: String, userId: String, userName: String) {
        self.token = token
        self.userId = userId
        self.userName = userName
    }
    
    public var token: String
    public var userId: String
    public var userName: String
}
