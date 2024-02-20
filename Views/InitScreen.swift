//
//  ContentView.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI
import PhotosUI

struct InitScreen: View {
    @State private var isMultiPlayer = false
    @State var startGame = false
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State var backgroundImages: [UIImage] = [UIImage(named: "DefaultImage1.jpg")!, UIImage(named: "DefaultImage2.jpg")!, UIImage(named: "DefaultImage3.jpg")!, UIImage(named: "DefaultImage4.jpg")!, UIImage(named: "DefaultImage5.jpg")!, UIImage(named: "DefaultImage6.jpg")!, UIImage(named: "DefaultImage7.jpg")!, UIImage(named: "DefaultImage8.jpg")!, UIImage(named: "DefaultImage10.jpg")!,UIImage(named: "DefaultImage9.jpg")!, UIImage(named: "DefaultImage10.jpg")!, UIImage(named: "DefaultImage11.jpg")!, UIImage(named: "DefaultImage12.jpg")!, UIImage(named: "DefaultImage13.jpg")!]
    @State var emailAddress = ""
    @State var password = ""
    @State var withLoginOption = false
    @State var userHasPickedImages = false
    
    var body: some View {
        VStack {
            HeaderView()
//                .onAppear(perform: {
//                _ = fillBackgroundImages()
//            })
            PhotosPicker("Choose 📷", selection: $photosPickerItems,maxSelectionCount: 10, selectionBehavior: .ordered, matching: .images)
                .foregroundColor(.black)
            Form {
                TextField("Email Address", text: $emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password;", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    //Attempt login
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.pink)
                        Text("Log In")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }.opacity(withLoginOption ? 1 : 0)
            
            Button {
                startGame.toggle()
            }label: {
                Text("Start game 🕺🏻, this screen will be used in the future to login and choose images")
                    .font(.system(size: 22, weight: .bold))
                //                    Text("Start Game")
                //                        .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(UIColor.systemBlue))
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(Color(UIColor.white))
            }
            .padding()
            .fullScreenCover(isPresented: $startGame, content: {
                GameFile(localBackgroundImage: backgroundImages)
//                GameFile(localBackgroundImage: userHasPickedImages ? backgroundImages : fillBackgroundImages())
            })
            .onChange(of: photosPickerItems) { _, _ in
                Task {
                    backgroundImages.removeAll()
                    for item in photosPickerItems {
                        if let data = try? await item.loadTransferable(type: Data.self){
                            if let image = UIImage(data: data){
                                backgroundImages.append(image)
                            }
                        }
                    }
                    photosPickerItems.removeAll()
                    userHasPickedImages = true
                    print("User picked \(backgroundImages.count) Images")
                    var startPoint = backgroundImages.count+1
                    while backgroundImages.count < 13 {
                        backgroundImages.append(UIImage(named: "DefaultImage\(startPoint).jpg")!)
                        startPoint+=1
                    }
                }
            }
        }.background(Color(UIColor.white))
    }

//    func fillBackgroundImages(){
//        print("User picked \(backgroundImages.count) Images, adding \(10-(backgroundImages.count))")
//        while backgroundImages.count < 10 {
//            backgroundImages.append(UIImage(named: "DefaultImage1.jpg")!)
//        }
//        print("size was under 10, new size \(backgroundImages.count)")
////        return backgroundImages
//    }
}



#Preview {
    InitScreen()
}
