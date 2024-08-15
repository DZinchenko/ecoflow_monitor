//
//  DeviceListView.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 11.08.2024.
//

import SwiftUI
import ecoflow_monitor_Domain
import ecoflow_monitor_Data

struct DeviceListView: View {
    @StateObject var viewModel = DeviceListViewModel()
    
    var body: some View {
        ScrollView {
            VStack (spacing: 15) {
                ForEach(self.viewModel.devices) { device in
                    DeviceListItemView(
                        deviceName: device.deviceName,
                        deviceSN: device.deviceSN,
                        observer: self.viewModel.deviceObserver.devices[device.deviceSN]!)
                }
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .onAppear {
            if !self.viewModel.isFirstLoaded {
                self.viewModel.load()
            }
        }
        
        .navigationBarBackButtonHidden()
        .navigationTitle(String(fromKey: "DeviceListView.Title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceListView()
        }
    }
}
