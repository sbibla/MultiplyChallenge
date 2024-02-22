//
//  LoginView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/21/24.
//

import SwiftUI

struct LoginView: View {
    @State var emailAddress = ""
    @State var password = ""
    var body: some View {
        Form {
            TextField("Email Address", text: $emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()                
            SecureField("Password;", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .autocorrectionDisabled()
            Button {
                //Attempt login
                print("Login user \(emailAddress) pass \(password)")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.pink)
                    Text("Log In")
                        .bold()
                        .foregroundColor(.white)
                }
            }.disabled(emailAddress.isEmpty || password.isEmpty)
        }
    }
}

#Preview {
    LoginView()
}
