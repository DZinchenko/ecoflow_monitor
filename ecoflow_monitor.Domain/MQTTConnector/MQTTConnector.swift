//
//  MQTTConnector.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation
import ecoflow_monitor_Data

public protocol MQTTConnector {
    func setCallbacks(onConnect: @escaping () -> Void,
                      onMsgReceive: @escaping (EcoflowDataResponse) -> Void,
                      onDisconnect: @escaping () -> Void)
    // setup MQTT credentials
    func setupMQTT(authData: EcoflowAuthData, mqttAuthData: EcoflowMQTTAuthData)
    // connect to the broker
    func connect()
    // disconnect from the broker
    func disconnect()
    // subscribe to device topic
    func subscribe(deviceSN: String)
    // unsubscribe from device topic
    func unsubscribe(deviceSN: String)
}
