//
//  HeaderView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/19/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.pink)
                .rotationEffect(Angle(degrees: 15))
            VStack {
                Text("Multiply Me")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                Text("Multiplication puzzle game")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 30)
        }
        .frame(width: UIScreen.main.bounds.width*3, height: 300)
        .offset(y: -120)
    }
}


#Preview {
    HeaderView()
}