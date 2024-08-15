//
//  EcoflowAPIDAO.swift
//  ecoflow_monitor.API
//
//  Created by Zinchenko Danulo on 23.07.2024.
//

import Foundation
import Alamofire

import ecoflow_monitor_Data

public class EcoflowAPIDAO: EcoflowAuthDAO, EcoflowDeviceDAO {
    public init() {}
    
    public func GetAuthData(email: String,
                            password: String,
                            onSuccess: @escaping (EcoflowAuthData) -> Void,
                            onError: @escaping (LoadError) -> Void) {
        let headers: HTTPHeaders = [
            "lang": "en_US",
            "Content-Type": "application/json"
        ]
        let params: [String: String] = [
            "email": email,
            "password": password,
            "scene": "IOT_APP",
            "userType": "ECOFLOW"
        ]
        
        AF.request("https://api.ecoflow.com/auth/login",
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .responseDecodable(of: EcoflowAuthResponse.self) { result in
                if let response = result.value {
                    onSuccess(EcoflowAuthData(
                        token: response.data.token,
                        userId: response.data.user.userId,
                        userName: response.data.user.name))
                }
                else if result.response?.statusCode == 200 {
                    onError(.badInput)
                }
                else {
                    onError(.unexpected)
                }
            }
    }
    
    public func GetMQTTAuthData(userId: String,
                                token: String,
                                onSuccess: @escaping (EcoflowMQTTAuthData) -> Void,
                                onError: @escaping (LoadError) -> Void) {
        let headers: HTTPHeaders = [
            "lang": "en_US",
            "Content-Type": "application/json",
            "authorization": "Bearer \(token)"
        ]
        let params: [String: String] = ["userId": userId]
        
        AF.request("https://api.ecoflow.com/iot-auth/app/certification",
                   method: .get,
                   parameters: params,
                   headers: headers)
            .responseDecodable(of: EcoflowMQTTAuthResponse.self) { result in
                guard let response = result.value,
                        let port = Int(response.data.port) else {
                    onError(.unexpected)
                    return
                }
                
                onSuccess(EcoflowMQTTAuthData(url: response.data.url,
                                              port: port,
                                              certificateAccount: response.data.certificateAccount,
                                              certificatePassword: response.data.certificatePassword))
            }
    }
    
    public func GetUserDevices(token: String,
                               onSuccess: @escaping ([EcoflowDevice]) -> Void,
                               onError: @escaping (LoadError) -> Void) {
        let headers: HTTPHeaders = [
            "lang": "en_US",
            "Content-Type": "application/json",
            "authorization": "Bearer \(token)"
        ]
        
        AF.request("https://api.ecoflow.com/iot-service/user/device",
                   method: .get,
                   headers: headers)
            .responseDecodable(of: EcoflowMQTTGetDevicesResponse.self) { result in
                guard let response = result.value else {
                    onError(.unexpected)
                    return
                }
                
                let res =
                response.data.bound.map { key, value in
                    EcoflowDevice(deviceSN: key,
                                  deviceName: String(value.deviceName.split(separator: "-").first ?? ""))
                }
                + response.data.share.map { key, value in
                    EcoflowDevice(deviceSN: key,
                                  deviceName: String(value.deviceName.split(separator: "-").first ?? ""),
                                  isShared: true)
                }
                
                onSuccess(res)
            }
    }
    
    private struct EcoflowAuthResponse: Decodable {
        struct Data: Decodable {
            struct User: Decodable {
                var userId: String
                var name: String
            }
            var token: String
            var user: User
        }
        var data: Data
    }
    
    private struct EcoflowMQTTAuthResponse: Decodable {
        struct Data: Decodable {
            var url: String
            var port: String
            var certificateAccount: String
            var certificatePassword: String
        }
        var data: Data
    }
    
    private struct EcoflowMQTTGetDevicesResponse: Decodable {
        struct DeviceData: Decodable {
            var deviceName: String
        }
        
        struct Data: Decodable {
            var bound: [String: DeviceData]
            var share: [String: DeviceData]
        }
        
        var data: Data
    }
    
}
