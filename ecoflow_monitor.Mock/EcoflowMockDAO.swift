//
//  EcoflowMockDAO.swift
//  ecoflow_monitor.Mock
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation
import ecoflow_monitor_Data

public class EcoflowMockDAO: EcoflowAuthDAO, EcoflowDeviceDAO {
    public init() { }
    
    public func GetAuthData(email: String, password: String, onSuccess: @escaping (ecoflow_monitor_Data.EcoflowAuthData) -> Void, onError: @escaping (ecoflow_monitor_Data.LoadError) -> Void) {
        onSuccess(EcoflowAuthData(token: "mock" + UUID().uuidString.replacingOccurrences(of: "-", with: ""),
                                  userId: "user12345678",
                                  userName: "MockUserName"))
    }
    
    public func GetMQTTAuthData(userId: String, token: String, onSuccess: @escaping (ecoflow_monitor_Data.EcoflowMQTTAuthData) -> Void, onError: @escaping (ecoflow_monitor_Data.LoadError) -> Void) {
        onSuccess(EcoflowMQTTAuthData(url: "mockurl-mqtt.com",
                                      port: 8883,
                                      certificateAccount: "mockAccountName",
                                      certificatePassword: "MockPassword"))
    }
    
    public func GetUserDevices(token: String, onSuccess: @escaping ([ecoflow_monitor_Data.EcoflowDevice]) -> Void, onError: @escaping (ecoflow_monitor_Data.LoadError) -> Void) {
        onSuccess([
            EcoflowDevice(deviceSN: "R5112EB2HF3S0K14", deviceName: "RIVER 2 Max"),
            EcoflowDevice(deviceSN: "RLIVSXQVWRN6R4UR", deviceName: "DELTA 2 Pro", isShared: true)
        ])
    }
}
