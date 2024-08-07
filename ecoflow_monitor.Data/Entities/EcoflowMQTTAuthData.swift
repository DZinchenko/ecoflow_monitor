//
//  EcoflowMQTTAuthData.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 23.07.2024.
//

import Foundation

public struct EcoflowMQTTAuthData {
    public init(url: String, port: Int, certificateAccount: String, certificatePassword: String) {
        self.url = url
        self.port = port
        self.certificateAccount = certificateAccount
        self.certificatePassword = certificatePassword
    }
    
    public var url: String
    public var port: Int
    public var certificateAccount: String
    public var certificatePassword: String
}
