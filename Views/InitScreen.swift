//
//  ContentView.swift
//  MultiplyChallenge
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI
import PhotosUI
import AudioToolbox
import AVFoundation


@MainActor
struct InitScreen: View {
    @State private var isMultiPlayer = false
    @State var startGame = false
    @State var withLoginOption = false
    @State var emailAddress = ""
    @State var password = ""
    @State var soundOn = true
    @State var tmpImage = UIImage(named: "Loading.jpg")!
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @StateObject private var PPviewModel = PhotoPickerViewModal()
    @StateObject private var userModel = UserDataViewModel()
    #warning("Consider adding @Env object so it can be used through the views https://medium.com/@mark.moeykens/swiftui-environmentobject-how-to-share-data-between-views-13f354011081#:~:text=You%20could%20pass%20your%20observable,object)%20to%20a%20parent%20view.")
  
    var body: some View {
        ZStack {
            VStack {
//                SettingsView()
                HeaderView(PPviewModelHeader: PPviewModel)
                Image(uiImage: tmpImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                
//                PhotosPicker(selection: $PPviewModel.imageSelections,maxSelectionCount: 50, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
//                    VStack {
//                        Text("Pick Many Image")
//                            .foregroundColor(.orange)
//#if DEBUG
//                        LoadedImagesView(selectedImages: PPviewModel.selectedImages)
//#endif
//                    }
//                }
//                #if DEBUG
//                                        LoadedImagesView(selectedImages: PPviewModel.selectedImages)
//                #endif
                LoginView(emailAddress: emailAddress, password: password)
                    .opacity(withLoginOption ? 1 : 0)
                Spacer()
                Button {
                    PPviewModel.appendDefaultImages()
                    logManager.shared.logMessage("Starting game for user \(emailAddress)", .debug)
                    startGame.toggle()
                    
                } label: {
                    Text("Start Game")
                        .padding()
                        .background {
                            Capsule()
                                .stroke(gradient, lineWidth: 1.5)
                                .saturation(1.8)
                        }
                        .bold()
                }
                Button {
//Do Something for testing button
                    
                }label: {
                    Text("🕺🏻New here? \n Create An Account")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
                .padding()
                .fullScreenCover(isPresented: $startGame, content: {
                    GameFile(localBackgroundImage: PPviewModel.selectedImages, currentLevel: userModel.highestLevel, highScore: userModel.highScore)

                })
                .onAppear{
                    Task {
//                            loadUserData()
//                        #warning("Move to load of class that deals with images or initializer")
                    }
                }
            }//.background(Color(UIColor.black)) //VStack
            
        }.environmentObject(UserDataViewModel())
    }
    


    

    
//    func playSounds(_ soundFileName : String) {
//        
//        if soundOn == false {             // Have a toggle to mute sound in app
//            logManager.shared.logMessage("All sounds are muted")
//            return
//        }
//        mySoundPtr = Sounds(CorrectAnswer: Bundle.main.url(forResource: "CorrectAnswer.wav", withExtension: nil), NextLevel: Bundle.main.url(forResource: "NextLevel.aiff", withExtension: nil), WrongAnswer:  Bundle.main.url(forResource: "WrongAnswer.aiff", withExtension: nil))
        //Init all sounds once
        
//        guard let bla.CorrectAnswer = Bundle.main.url(forResource: "CorrectAnswer.wav", withExtension: nil) else {
//            fatalError("Unable to find \(soundFileName) in bundle")
//        }
        
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
//        } catch {
//            logManager.shared.logMessage(error.localizedDescription, .warning)
//        }
//        audioPlayer.play()
//    }
    
}

#Preview {
    InitScreen()
//    InitScreen( mySoundPtr: InitScreen.Sounds(CorrectAnswer: nil, NextLevel: nil, WrongAnswer: nil))
}
