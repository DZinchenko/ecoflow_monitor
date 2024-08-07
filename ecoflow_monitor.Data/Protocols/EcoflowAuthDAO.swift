//
//  EcoflowAuthDAO.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 23.07.2024.
//

import Foundation

public protocol EcoflowAuthDAO {
    func GetAuthData(email: String,
                     password: String,
                     onSuccess: @escaping (EcoflowAuthData) -> Void,
                     onError: @escaping () -> Void)
    
    func GetMQTTAuthData(userId: String,
                         token: String,
                         onSuccess: @escaping (EcoflowMQTTAuthData) -> Void,
                         onError: @escaping () -> Void)
}
