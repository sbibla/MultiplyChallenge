//
//  ContentView.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI


struct InitScreen: View {
    @State var startGame = false
    @State var backgroundImageDictionary: [Int: UIImage] = [:]

    
    var body: some View {
        
        ZStack {
            Text("")
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(.black)
            VStack(spacing: 0) {
                Button {
                    userPickImages()
                }label: {

                        Spacer()
                    Image(systemName: "gear")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(UIColor.systemGray))
                }
                Button {
                    defaultImageDictionary()
                    startGame.toggle()
                }label: {
                    Text("Start game 🕺🏻")
                        .font(.system(size: 122, weight: .bold))
//                    Text("Start Game")
//                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(UIColor.systemBlue))
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(Color(UIColor.black))
                }
            }
            .padding()
        .fullScreenCover(isPresented: $startGame, content: {GameFile()})
        }
    }
    func defaultImageDictionary(){
        let count = 1...4
        for imageNumber in count {
            guard let loadedImage = UIImage(named: "DefaultImage\(imageNumber).heic") else {
                perror("Failed to set default images")
                return
            }
            backgroundImageDictionary.updateValue(loadedImage, forKey: imageNumber)
            print("successfully loaded image \(loadedImage.imageAsset?.value(forKey: "assetName") ?? "nil") ")
        }
        print("loaded \(backgroundImageDictionary.count) images")
    }
    func userPickImages(){
        
    }
}

#Preview {
    InitScreen()
}
