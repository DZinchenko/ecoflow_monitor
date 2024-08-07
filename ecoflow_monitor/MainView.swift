//
//  MainView.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 29.07.2024.
//

import SwiftUI
import ecoflow_monitor_Data

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    init(authData: EcoflowAuthData, mqttAuthData: EcoflowMQTTAuthData) {
        self.viewModel = MainViewModel(authData: authData, mqttAuthData: mqttAuthData)
    }
    
    struct ParameterView: View {
        var key: String
        var value: String
        var type: String
        
        internal init(key: String, parameter: EcoflowDataResponse.Parameter) {
            self.key = key
            
            switch parameter {
            case let .int(intVal):
                self.value = String(intVal)
                self.type = "Int"
            case let .double(doubleVal):
                self.value = String(doubleVal)
                self.type = "Float"
            case let .string(stringVal):
                self.value = stringVal
                self.type = "String"
            case let .other(stringVal):
                self.value = stringVal
                self.type = "Unknown"
            }
        }
        
        var body: some View {
            HStack {
                Text(key + ":")
                Spacer()
                Text(self.value)
                    .frame(width: 60)
                Text(self.type)
                    .frame(width: 60)
                
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if self.viewModel.isConnected {
                    Text("Connected")
                }
                else {
                    Text("Not connected")
                        .foregroundColor(Color.red)
                }
                
                Spacer()
                
                Button(self.viewModel.isConnected ? "Disconnect": "Connect") {
                    if self.viewModel.isConnected {
                        self.viewModel.disconnect()
                    }
                    else {
                        self.viewModel.connect()
                    }
                }
            }
            HStack {
                TextField("Device SN", text: self.$viewModel.deviceSN)
                    .disabled(self.viewModel.isSubscribed)
                if !self.viewModel.isSubscribed {
                    Button("Subscribe", action: self.viewModel.subscribe)
                        .disabled(!self.viewModel.isConnected)
                }
                else {
                    Button("Unsubscribe", action: self.viewModel.unsubscribe)
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 10)
            
            Rectangle().frame(height: 1)
            
            HStack {
                Text("Key")
                
                Spacer()
                
                Text("Value")
                    .frame(width: 60)
                Text("Of type")
                    .frame(width: 60)
            }
            
            Rectangle().frame(height: 1)
            
            ScrollView {
                ForEach(Array(self.viewModel.parameters.keys), id: \.self) {
                    key in
                    ParameterView(key: key, parameter: self.viewModel.parameters[key]!)
//                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                }
            }
        }
        .padding(.horizontal, 10)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authData: EcoflowAuthData(token: "", userId: "", userName: ""),
                 mqttAuthData: EcoflowMQTTAuthData(url: "", port: -1, certificateAccount: "", certificatePassword: ""))
    }
}
