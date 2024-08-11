//
//  LoginViewModel.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 29.07.2024.
//

import Foundation
import ecoflow_monitor_Data
import ecoflow_monitor_Domain

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var serial = ""
    
    @Published var isLoading = false
    @Published var isAuthSuccess = false
    @Published var isAuthError = false
    @Published var isInternetError = false
    
    private var authContext = EcoflowAuthContext()
    
    func signIn() {
        self.isLoading = true
        self.authContext.getMQTTAuthData(email: self.email, password: self.password) {
            self.isAuthSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }
        } onError: { error in
            self.isLoading = false
            switch error {
            case .badInput:
                self.isAuthError = true
            case .unexpected:
                self.isInternetError = true
            }
        }
    }
    
    func getAuthData() -> (authData: EcoflowAuthData, mqttAuthData: EcoflowMQTTAuthData)? {
        if self.isAuthSuccess,
           let authData = self.authContext.authData,
           let mqttAuthData = self.authContext.mqttAuthData
        {
            return (authData: authData, mqttAuthData: mqttAuthData)
        }
        else {
            return nil
        }
    }
}
