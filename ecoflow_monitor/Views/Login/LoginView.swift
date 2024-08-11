//
//  LoginView.swift
//  ecoflow_monitor
//
//  Created by Zinchenko Danulo on 22.07.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            if let data = self.viewModel.getAuthData() {
                NavigationLink("",
                               destination: MainView(authData: data.authData, mqttAuthData: data.mqttAuthData),
                               isActive: self.$viewModel.isAuthSuccess)
            }
            
            Text(String(fromKey: "LoginView.Title"))
                .font(.system(.title, weight: .heavy))
                .padding(.top, 120)
            
            InputFieldView(text: self.$viewModel.email, placeholder: String(fromKey: "LoginView.EmailPlaceholder"))
            InputFieldView(text: self.$viewModel.password, placeholder: String(fromKey: "LoginView.PasswordPlaceholder"), isSecure: true)
            
            if self.viewModel.isAuthError {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .bold()
                    
                    Text(String(fromKey: "LoginView.NoAccountWarning"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .foregroundColor(.warning)
                .background(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.warning)
                        .opacity(0.15)
                })
                .onTapGesture {
                    self.viewModel.isAuthError = false
                }
            }
            
            
            Button(action: self.viewModel.signIn) {
                RoundedRectangle(cornerRadius: 12).fill(Color.button)
                    .overlay {
                        Text(String(fromKey: "LoginView.SingInButtonText"))
                            .bold()
                            .foregroundColor(.primary)
                    }
            }
            .frame(height: 48)
            .animation(.easeOut, value: self.viewModel.isAuthError)
            
            if self.viewModel.isLoading {
                ProgressView()
                    .padding(.leading, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .alert(String(fromKey: "LoginView.NoConnectionAlertTitle"), isPresented: self.$viewModel.isInternetError) {
            Button("OK") { }
        }
    }
    
    struct InputFieldView: View {
        @Binding var text: String
        var placeholder: String
        var isSecure: Bool = false
        
        var body: some View {
            Group {
                if isSecure {
                    SecureField("", text: $text)
                }
                else{
                    TextField("", text: $text)
                }
            }
            .overlay(alignment: .leading, content: {
                Group{
                    if self.text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.placeholder)
                    }
                }
            })
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.fieldBackground)
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
