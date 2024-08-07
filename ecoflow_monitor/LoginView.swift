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
        VStack(spacing: 20) {
            if let data = self.viewModel.getAuthData() {
                NavigationLink("",
                               destination: MainView(authData: data.authData, mqttAuthData: data.mqttAuthData),
                               isActive: self.$viewModel.isAuthSuccess)
            }
            
            Text("Sign in:")
                .font(.title3)
            Field(text: self.$viewModel.email, name: "Email")
            Field(text: self.$viewModel.password, name: "Password", isSecure: true)
            
            Button(action: self.viewModel.signIn) {
                RoundedRectangle(cornerRadius: 20).fill(Color.gray)
                    .overlay {
                        Text("Sign in")
                            .foregroundColor(.white)
                    }
            }
            .frame(height: 50)
            .padding(.vertical, 10)
            
            if self.viewModel.isLoading {
                ProgressView()
                    .padding(.leading, 20)
                    .animation(.default, value: self.viewModel.isLoading)
            }
            
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.top, 150)
    }
    
    struct Field: View {
        @Binding var text: String
        var name: String
        var isSecure: Bool = false
        
        var body: some View {
            VStack {
                if isSecure {
                    SecureField(name, text: $text)
                }
                else{
                    TextField(name, text: $text)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 2)
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
