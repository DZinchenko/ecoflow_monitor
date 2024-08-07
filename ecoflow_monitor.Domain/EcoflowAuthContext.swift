//
//  EcoflowAuthContext.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 27.07.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_API

public class EcoflowAuthContext {
    public private(set) var authData: EcoflowAuthData?
    public private(set) var mqttAuthData: EcoflowMQTTAuthData?
    
    private var authDAO: EcoflowAuthDAO = EcoflowAuthAPIDAO()
    
    public init() {}
    
    public func getMQTTAuthData(email: String,
                         password: String,
                         onSuccess: @escaping () -> Void,
                         onError: @escaping () -> Void) {
        self.authDAO.GetAuthData(
            email: email,
            password: Data(password.utf8).base64EncodedString())
        { authData in
            self.authData = authData
            self.authDAO.GetMQTTAuthData(
                userId: authData.userId,
                token: authData.token) { mqttAuthData in
                    self.mqttAuthData = mqttAuthData
                    onSuccess()
                } onError: {
                    onError()
                }

        } onError: {
            onError()
        }
    }
}
