//
//  MockMQTTConnector.swift
//  ecoflow_monitor.Mock
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_Domain

public class MockMQTTConnector: MQTTConnector {
    private var onConnect: (() -> Void)?
    private var onMsgReceive: ((EcoflowDataResponse) -> Void)?
    private var onDisconnect: (() -> Void)?
    private var deviceNum = 0
    private var responseParams: [[String:EcoflowDataResponse.Parameter]] = [
        [ KnownParameters.pdInputWatts.keys.first! : .int(10),
          KnownParameters.pdOutputWatts.keys.first! : .int(0),
          KnownParameters.stateOfCharge.keys.first! : .double(55.42) ],
        [ KnownParameters.pdInputWatts.keys.first! : .int(0),
          KnownParameters.pdOutputWatts.keys.first! : .int(10)]
    ]
    
    public init() { }
    
    public func setCallbacks(onConnect: @escaping () -> Void,
                             onMsgReceive: @escaping (EcoflowDataResponse) -> Void,
                             onDisconnect: @escaping () -> Void) {
        self.onConnect = onConnect
        self.onMsgReceive = onMsgReceive
        self.onDisconnect = onDisconnect
    }
    
    public func setupMQTT(authData: EcoflowAuthData,
                          mqttAuthData: EcoflowMQTTAuthData) {
        
    }
    
    public func connect() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.onConnect?()
        }
    }
    
    public func disconnect() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.onDisconnect?()
        }
    }
    
    public func subscribe(deviceSN: String) {
        self.onDeviceSubscribe(deviceSN: deviceSN)
    }
    
    public func unsubscribe(deviceSN: String) { }
    
    private func onDeviceSubscribe(deviceSN: String) {
        let i = self.deviceNum
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.onMsgReceive?(.init(
                timestamp: .now,
                device: deviceSN,
                moduleType: "1",
                params: self.responseParams[i]))
        }
        self.deviceNum += 1
    }
}
