//
//  EcoflowDevicesContext.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 12.08.2024.
//

import Foundation
import ecoflow_monitor_Data

public class EcoflowDevicesContext: ObservableObject {
    private var authContext: EcoflowAuthContext
    private var mqttConnector: MQTTConnector
    
    @Published public private(set) var isConnected = false
    @Published public private(set) var isConnecting = false
    @Published public private(set) var devices: [String: EcoflowDeviceObserver] = [:]
    
    public init(authContext: EcoflowAuthContext, mqttConnector: MQTTConnector) {
        self.authContext = authContext
        self.mqttConnector = mqttConnector
        
        self.mqttConnector.setCallbacks(
            onConnect: {
                self.isConnected = true
                self.isConnecting = false
                print("connected")
                
                if !self.devices.isEmpty {
                    for device in self.devices {
                        self.subscribeDevice(deviceSN: device.key)
                    }
                }
            },
            onMsgReceive: self.msgReceived,
            onDisconnect:  {
                self.isConnected = false
                self.isConnecting = false
            })
    }
    
    public func connect() {
        guard let authData = self.authContext.authData,
                let mqttAuthData = self.authContext.mqttAuthData
        else { return } //TODO: log warning
        
        self.isConnecting = true
        self.mqttConnector.setupMQTT(authData: authData, mqttAuthData: mqttAuthData)
        self.mqttConnector.connect()
    }
    
    public func addDevice(deviceSN: String) {
        self.devices[deviceSN] = EcoflowDeviceObserver()
        if self.isConnected {
            self.subscribeDevice(deviceSN: deviceSN)
        }
    }
    
    private func subscribeDevice(deviceSN: String) {
        print("sub " + deviceSN)
        self.mqttConnector.subscribe(deviceSN: deviceSN)
    }
    
    private func msgReceived(dataResponse: EcoflowDataResponse) {
        guard let observer = self.devices[dataResponse.deviceSN]
        else { return } //TODO: log warning
        
        observer.update(message: dataResponse)
    }
}
