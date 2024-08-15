//
//  DeviceListItemView.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 14.08.2024.
//

import Foundation
import SwiftUI
import ecoflow_monitor_Domain

struct DeviceListItemView: View {
    @ObservedObject var viewModel: DeviceListItemViewModel
    @ObservedObject var observer: EcoflowDeviceObserver
    var deviceName: String
    var deviceSN: String
    
    init(deviceName: String, deviceSN: String, observer: EcoflowDeviceObserver) {
        self.deviceName = deviceName
        self.deviceSN = deviceSN
        self.viewModel = .init(observer: observer)
        self.observer = observer
    }
    
    var stateString: String {
        if !self.viewModel.observer.firstLoadTimePassed {
            return String(fromKey: "DeviceListItemView.Loading")
        }
        
        if !self.viewModel.observer.isOnline {
            return String(fromKey: "DeviceListItemView.Offline")
        }
        
        guard let inputSum = self.viewModel.inputWattsSum,
              let outputSum = self.viewModel.outputWattsSum
        else {
            return String(fromKey: "DeviceListItemView.Loading")
        }
        
        var ret: String
        
        if inputSum > 0 {
            ret = String(fromKey: "DeviceListItemView.Charging")
        }
        else if outputSum > 0 {
            ret = String(fromKey: "DeviceListItemView.Discharging")
        }
        else {
            ret = String(fromKey: "DeviceListItemView.Idle")
        }
        
        if let socValue = self.viewModel.stateOfCharge {
            ret += " \(socValue)%"
        }
        
        return ret
    }
    
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                Text(self.deviceName)
                    .bold()
                
                Text(self.deviceSN)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
            
            Text(self.stateString)
                .foregroundColor(.secondaryText)
        }
    }
}
