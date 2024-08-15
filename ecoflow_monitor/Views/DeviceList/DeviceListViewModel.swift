//
//  DeviceListViewModel.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_Domain

class DeviceListViewModel: ObservableObject {
    @Inject private var authContext: EcoflowAuthContext
    @Inject private var deviceDAO: EcoflowDeviceDAO
    
    @InjectObservable var deviceObserver: EcoflowDevicesContext
    
    @Published var devices: [EcoflowDevice] = []
    @Published var isLoading = false
    @Published var isFirstLoaded = false
    
    init() {
        self.deviceObserver.connect()
    }
    
    func load() {
        guard let token = self.authContext.authData?.token
        else { return }
        
        self.isLoading = true
        
        self.deviceDAO.GetUserDevices(
            token: token,
            onSuccess: { devices in
                self.devices = devices
                self.isLoading = false
                for device in devices {
                    self.deviceObserver.addDevice(deviceSN: device.deviceSN)
                }
            },
            onError: { error in
                self.isLoading = false
            })
    }
}
