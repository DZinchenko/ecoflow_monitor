//
//  EcoflowMQTTConnector.swift
//  ecoflow_monitor.Domain
//
//  Created by Zinchenko Danulo on 27.07.2024.
//

import Foundation
import CocoaMQTT
import ecoflow_monitor_Data

public class EcoflowMQTTConnector : MQTTConnector {
    private var mqttClient: CocoaMQTT5?
    private var onConnect: (() -> Void)?
    private var onMsgReceive: ((EcoflowDataResponse) -> Void)?
    private var onDisconnect: (() -> Void)?
    
    public init() { }
    
    public func setCallbacks(onConnect: @escaping () -> Void,
                             onMsgReceive: @escaping (EcoflowDataResponse) -> Void,
                             onDisconnect: @escaping () -> Void) {
        self.onConnect = onConnect
        self.onMsgReceive = onMsgReceive
        self.onDisconnect = onDisconnect
    }
    
    public func setupMQTT(authData: EcoflowAuthData, mqttAuthData: EcoflowMQTTAuthData) {
        let deviceUUID = UIDevice.current.identifierForVendor!.uuidString
        let clientID = "ANDROID_\(deviceUUID)_\(authData.userId)"
        
        let mqtt5 = CocoaMQTT5(clientID: clientID, host: mqttAuthData.url, port: UInt16(mqttAuthData.port))
        mqtt5.username = mqttAuthData.certificateAccount
        mqtt5.password = mqttAuthData.certificatePassword
        mqtt5.enableSSL = true
        mqtt5.keepAlive = 60
        
        mqtt5.didDisconnect = { mqtt, error in
            self.onDisconnect?()
        }
        
        mqtt5.didConnectAck = { mqtt, code, ack in
            self.onConnect?()
        }
        
        mqtt5.didReceiveMessage = { mqtt, message, id, a in
            if let mqttData = try? JSONDecoder().decode(
                EcoflowMQTTData.self,
                from: Data(message.payload)
            ) {
                
                let response = EcoflowDataResponse(
                    timestamp: mqttData.timestamp,
                    device: String(message.topic.split(separator: "/").last ?? ""),
                    moduleType: mqttData.moduleType,
                    params: mqttData.params.compactMapValues({ value in
                        switch value {
                        case let .int(intVal):
                            return EcoflowDataResponse.Parameter.int(intVal)
                        case let .double(doubleVal):
                            return EcoflowDataResponse.Parameter.double(doubleVal)
                        case let .bool(boolVal):
                            return EcoflowDataResponse.Parameter.int(boolVal ? 1 : 0)
                        case .array:
                            return EcoflowDataResponse.Parameter.other(value.toString())
                        case .dictionary:
                            return EcoflowDataResponse.Parameter.other(value.toString())
                        case let .string(stringVal):
                            return EcoflowDataResponse.Parameter.string(stringVal)
                        case .unknown:
                            return nil
                        }
                        
                    }))
                
                self.onMsgReceive?(response)
            }
            
        }
        
        self.mqttClient = mqtt5
    }
    
    public func connect() {
        guard let mqttClient = mqttClient else {
            self.onDisconnect?()
            return
        }
        
        if !mqttClient.connect() {
            self.onDisconnect?()
        }
    }
    
    public func disconnect() {
        self.mqttClient?.disconnect()
    }
    
    public func subscribe(deviceSN: String) {
        if let mqttClient = self.mqttClient {
            mqttClient.subscribe("/app/device/property/\(deviceSN)")
        }
    }
    
    public func unsubscribe(deviceSN: String) {
        if let mqttClient = self.mqttClient {
            mqttClient.unsubscribe("/app/device/property/\(deviceSN)")
        }
    }
}

fileprivate struct EcoflowMQTTData: Decodable {
    var timestamp: Date
    var moduleType: String
    var params: [String: AnyDecodable]
}

fileprivate enum AnyDecodable: Decodable {
    case int(Int)
    case double(Double)
    case bool(Bool)
    case array([AnyDecodable])
    case dictionary([String:AnyDecodable])
    case string(String)
    case unknown
    
    // Implement the Decodable protocol
    init(from decoder: Decoder) throws {
        // Create a container with a single value
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let arrayValue = try? container.decode([AnyDecodable].self) {
            self = .array(arrayValue)
        } else if let dictionaryValue = try? container.decode([String: AnyDecodable].self) {
            self = .dictionary(dictionaryValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .unknown
            print("Error decoding \(AnyDecodable.self) with coding path \(decoder.codingPath).")
        }
    }
    
    func toString() -> String {
        switch self {
        case let .int(intVal):
            return String(intVal)
        case let .double(doubleVal):
            return String(doubleVal)
        case let .bool(boolVal):
            return String(boolVal)
        case let .array(arrayVal):
            return "[" + arrayVal.map{ $0.toString() }.joined(separator: ", ") + "]"
        case let .dictionary(dictVal):
            return "[" + dictVal.map{ $0 + ": " + $1.toString() }.joined(separator: ", ") + "]"
        case let .string(stringVal):
            return stringVal
        case .unknown:
            return ""
        }
    }
}
