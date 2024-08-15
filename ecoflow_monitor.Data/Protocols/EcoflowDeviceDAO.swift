//
//  EcoflowDeviceDAO.swift
//  ecoflow_monitor.Data
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation

public protocol EcoflowDeviceDAO {
    func GetUserDevices(token: String,
                        onSuccess: @escaping ([EcoflowDevice]) -> Void,
                        onError: @escaping (LoadError) -> Void)
}
