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
    //Setting to true for MVP until setting screen is ready
    @State var showImagePreview = true
    @State private var showSettings = false
    @State private var showDevMenu = false
    @State private var devTestMode = false
    @State private var devSoundsMuted = false
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    @StateObject private var PPviewModel = PhotoPickerViewModal()
    @StateObject private var userModel = UserDataViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                if(showImagePreview == false){
                    Image("geometryImage")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
                VStack(spacing:30) {
                    ImageInCircle(circleImage: tmpImage)
                        .onLongPressGesture(minimumDuration: 5) {
                            showDevMenu = true
                        }
                    Text("Solve the tile to Unveil")
                        .font(.system(size: 25))
                        .foregroundColor(.brandPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Text("One Tile at a Time!")
                        .font(.system(size: 25))
                        .foregroundColor(Color.primary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Spacer()
                    
                    //#if DEBUG
                    if(showImagePreview) {
                        LoadedImagesView(selectedImages: PPviewModel.selectedImages)
                    }
                    //#endif
                    
                    //                LoginView()
                    //                    .opacity(withLoginOption ? 1 : 0)
                    Button {
                        PPviewModel.appendDefaultImages(isPokemonMode: true)
                        logManager.shared.logMessage("Starting game for user \(emailAddress)", .debug)
                        startGame.toggle()
                        
                    } label: {
                        Text("Start Game")
                            .padding()
                            .background {
                                Capsule()
                                    .stroke(gradient, lineWidth: 3.5)
                                    .saturation(1.8)
                            }
                            .font(.system(size: 30))
                            .foregroundColor(Color.primary)
//                            .bold()
                    }
                    .fullScreenCover(isPresented: $startGame, content: {
                        GameFile(localBackgroundImage: PPviewModel.selectedImages, soundsMuted: devSoundsMuted, displayStartGameButton: false, currentLevel: userModel.user.highestLevel, testMode: devTestMode, highScore: userModel.user.highScore)
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker(selection: $PPviewModel.imageSelections,maxSelectionCount: 50, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
                            Image(systemName: "plus")
                            //                            .foregroundColor(Color(.white))
                                .imageScale(.large)
                                .frame(width: 64, height: 64)
                                .modifier(StandardButtonStyle())
                        }                        
                    }
                }
            }
        }
        .environmentObject(UserDataViewModel())
        .sheet(isPresented: $showDevMenu) {
            NavigationView {
                Form {
                    Section(header: Text("Game")) {
                        Toggle("All Answers Correct", isOn: $devTestMode)
                    }
                    Section(header: Text("Display")) {
                        Toggle("Show Image Preview", isOn: $showImagePreview)
                    }
                    Section(header: Text("Audio")) {
                        Toggle("Mute Sounds", isOn: $devSoundsMuted)
                    }
                }
                .navigationTitle("Developer Menu")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { showDevMenu = false }
                    }
                }
            }
        }
    }
}

#Preview {
    InitScreen()
    //    InitScreen( mySoundPtr: InitScreen.Sounds(CorrectAnswer: nil, NextLevel: nil, WrongAnswer: nil))
}

struct SettingsGear: View {
    var body: some View {
        Spacer()
    }
}

