//
//  MainViewModel.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 29.07.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_Domain

class MainViewModel: ObservableObject {
    @Published var deviceSN = ""
    @Published var isConnected = false
    @Published var isSubscribed = false
    @Published var parameters: [String:EcoflowDataResponse.Parameter] = [:]
    
    private var mqttConnector: EcoflowMQTTConnector!
    private var authData: EcoflowAuthData
    private var mqttAuthData: EcoflowMQTTAuthData
    
    init(authData: EcoflowAuthData, mqttAuthData: EcoflowMQTTAuthData) {
        self.authData = authData
        self.mqttAuthData = mqttAuthData
        
        self.mqttConnector = EcoflowMQTTConnector(
            onConnect: { self.isConnected = true},
            onMsgReceive: self.onMsgReceive,
            onDisconnect: {
                self.isConnected = false
                self.isSubscribed = false
            })
        
        self.mqttConnector.setupMQTT(authData: self.authData, mqttAuthData: self.mqttAuthData)
    }
    
    func connect() {
        self.mqttConnector.connect()
    }
    
    func disconnect() {
        self.mqttConnector.disconnect()
    }
    
    func subscribe() {
        self.mqttConnector.subscribe(deviceSN: self.deviceSN)
        self.isSubscribed = true
    }
    
    func unsubscribe() {
        self.mqttConnector.unsubscribe(deviceSN: self.deviceSN)
        self.isSubscribed = false
    }
    
    private func onMsgReceive(message: EcoflowDataResponse) {
        for (paramName, paramVal) in message.params {
            self.parameters[paramName] = paramVal
        }
    }
}
