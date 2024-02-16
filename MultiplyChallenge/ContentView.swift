//
//  ContentView.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI


struct ContentView: View {
    @State var startGame = false
    
    
    var body: some View {
        VStack {
            Button {
                startGame.toggle()
            }label: {
                Text("Change 3")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(.indigo)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $startGame, content: {GameFile()})
    }
        
//        .fullScreenCover(isPresented: $startGame, onDismiss: .nil, content: {
//        GameFile()
//    })
//    .fullScreenCover(isPresented: $shouldShowGame, content: {
//        GameFile()
//    })

    
}

#Preview {
    ContentView()
}
