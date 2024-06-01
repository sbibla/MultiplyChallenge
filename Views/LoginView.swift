//
//  LoginView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/21/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Form {
                TextField("Email Address", text: $viewModel.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                SecureField("Password;", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                Button {
                    //Attempt login
                    viewModel.login()
                    logManager.shared.logMessage("Login user \(viewModel.emailAddress) pass \(viewModel.password)", .debug)
                } label: {
                    Text("Log In")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 260, height: 50)
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(10)
                    
                }
            }/*.disabled(viewModel.emailAddress.isEmpty || viewModel.password.isEmpty)*/
        }.alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    LoginView()
}


