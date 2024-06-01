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
    @State var showImagePreview = false
    @State private var showSettings = false
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @StateObject private var PPviewModel = PhotoPickerViewModal()
    @StateObject private var userModel = UserDataViewModel()
    
    var tapGesture: some Gesture {
        TapGesture(count: 3)
            .onEnded {
                showImagePreview.toggle()
            }
    }
    
    var body: some View {
        ZStack {
            VStack {
                //                SettingsView()
                HeaderView(PPviewModelHeader: PPviewModel)
                ImageInCircle(circleImage: tmpImage)
                    .gesture(tapGesture)
#if DEBUG
                if(showImagePreview) {
                    LoadedImagesView(selectedImages: PPviewModel.selectedImages)
                }
#endif
                
                LoginView()
                    .opacity(withLoginOption ? 1 : 0)
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
                .fullScreenCover(isPresented: $startGame, content: {
                    GameFile(localBackgroundImage: PPviewModel.selectedImages, currentLevel: userModel.user.highestLevel, highScore: userModel.user.highScore)
                    
                })
                if withLoginOption == true {
                    
                    Button {
                        //Do Something for testing button
                        showSettings.toggle()
                    }label: {
                        Text("🕺🏻New here? \n Create An Account")
                            .font(.system(size: 15))
                            .foregroundColor(Color(UIColor.systemBlue))
                    }
                    .fullScreenCover(isPresented: $showSettings, content: {
                        AppSettingsView()
                    })
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
