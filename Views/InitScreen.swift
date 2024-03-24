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
    @State private var photosPickerItems: [PhotosPickerItem] = []
    @State var backgroundImages: [UIImage] = []
    @State var emailAddress = ""
    @State var password = ""
    @State var highScore = 0
    @State var soundOn = true
    @State var withLoginOption = false
    @State var userHasPickedImages = false
    @State var tmpImage = UIImage(named: "Loading.jpg")!
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @State var userPickedImages = 0
    @StateObject private var PPviewModel = PhotoPickerViewModal()
  
    var body: some View {
        ZStack {
            VStack {
                
                HeaderView()
                Image(uiImage: tmpImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                
                PhotosPicker(selection: $PPviewModel.imageSelections, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
                    VStack {
                        Text("Pick Many Image")
                            .foregroundColor(.orange)
#if DEBUG
                        LoadedImagesView(selectedImages: PPviewModel.selectedImages)
#endif
                    }
                }
                
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
                    GameFile(localBackgroundImage: PPviewModel.selectedImages, highScore: highScore)

                })
                .onAppear{
                    Task {
                            loadUserData()
                        #warning("Move to load of class that deals with images or initializer")
                    }
                }
            }//.background(Color(UIColor.black)) //VStack
        }
    }
    
    func loadUserData(){
      
        //load highscore
        loadHighScoreData()
    }
    func loadHighScoreData(){
        let savedScore = UserDefaults.standard.integer(forKey: "highScore")
        if (savedScore == 0) {
            highScore = 0
            logManager.shared.logMessage("No saved highScore", .warning)
        } else {
            highScore = savedScore
            logManager.shared.logMessage("Found high score value: \(savedScore)", .info)
        }
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
