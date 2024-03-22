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

#warning("Add the following to the code (parked in 3/22/24)")
/*Flow to add
 1. on start load files from local storage
 2. if user picked images, add to loaded files at the start and save the new long array
 3. if no images picked, use the loaded images
 
 */
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
    //            }
//            VStack {
                
                HeaderView()
                Image(uiImage: tmpImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                if !backgroundImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(backgroundImages, id: \.self) {image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                
//                PhotosPicker("Choose Images (\(backgroundImages.count))", selection: $photosPickerItems,maxSelectionCount: 20, selectionBehavior: .ordered, matching: .images)
//                                .foregroundColor(.red)
                
                PhotosPicker(selection: $PPviewModel.imageSelections, matching: .any(of: [.images, .screenshots, .panoramas, .bursts, .livePhotos])) {
                    Text("Pick Many Images \(backgroundImages.count)")
                        .foregroundColor(.orange)
                    
                    if !PPviewModel.selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(PPviewModel.selectedImages, id: \.self) {image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                
                LoginView(emailAddress: emailAddress, password: password)
                    .opacity(withLoginOption ? 1 : 0)
                Spacer()
                Button {
                    logManager.shared.logMessage("Starting game for user \(emailAddress)", .debug)
                    if !PPviewModel.selectedImages.isEmpty {
                        PPviewModel.saveImagesLocally(folderName: "userBackgroundImages")
                    }
                    
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
                    logManager.shared.logMessage("Calling copyImagesToArray() func", .debug)
//                    startBonusLevel.toggle()
//                    loadImagesFromLocalStorage()
                    Task {
                        await copyImagesToArray()
                    }
                    
                }label: {
                    Text("🕺🏻New here? \n Create An Account")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
                .padding()
                .fullScreenCover(isPresented: $startGame, content: {
//                    GameFile(localBackgroundImage: backgroundImages, highScore: highScore)
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
    //Call on first time run
    func loadDefaultImages(){
        var startPoint = 1
        while backgroundImages.count < 13 {
            backgroundImages.append(UIImage(named: "DefaultImage\(startPoint).jpg")!)
            startPoint+=1
        }
//        saveImagesToLocalStorage()
    }
    func copyImagesToArray() async  {
////        backgroundImages.removeAll()
//        for item in photosPickerItems {
//            if let data = try? await item.loadTransferable(type: Data.self){
//                if let image = UIImage(data: data){
//                    backgroundImages.append(image)
//                    logManager.shared.logMessage("\(#line):added user picked Image: \(image.description)", .debug)
//                }
//            } else {
//                logManager.shared.logMessage("Failed to load user images", .warning)
//            }
//        }
////        photosPickerItems.removeAll()
//        userHasPickedImages = true
//        if backgroundImages.count == 0 {
//            logManager.shared.logMessage("Called for 2nd time, exiting", .warning)
//            return
//        }
//        userPickedImages = backgroundImages.count
//
//        logManager.shared.logMessage("User picked \(userPickedImages) Images", .debug)
//        var startPoint = backgroundImages.count+1
//        while backgroundImages.count < 13 {
//            backgroundImages.append(UIImage(named: "DefaultImage\(startPoint).jpg")!)
//            startPoint+=1
//        }
//        saveImagesToLocalStorage()
//        #warning("Saving files twice (2nd time is after photosPicketItems.removeAll()")
    }
    
    @State private var storedImage: UIImage?
    
    func loadUserData(){
        //loadLocalImages from Storage
        if loadImagesFromLocalStorage() == false {
            logManager.shared.logMessage("Running for the first time, loading default images", .debug)
            loadDefaultImages()
        }else {
            logManager.shared.logMessage("\(backgroundImages.count) Images successfully loaded from local storage", .debug)
        }
        
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
    
    #warning("ToDo: Update load to include more than 13 images, if less take from default.")
    func loadImagesFromLocalStorage() -> Bool{
        backgroundImages.removeAll()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var startPoint = 1
        var name = "UserImage\(startPoint).jpg"
        var imagePath = path
            .appendingPathComponent("userBackgroundImages")
            .appendingPathComponent(name)
        
    
        while backgroundImages.count < 13 {
            if !FileManager.default.fileExists(atPath: imagePath.path){
                logManager.shared.logMessage("File \(imagePath.absoluteString) is missing, exiting", .warning)
                return false
            }
            logManager.shared.logMessage("Image loaded \(imagePath.absoluteString)", .debug)
            tmpImage = UIImage(contentsOfFile: imagePath.path)!
            backgroundImages.append(tmpImage)
            startPoint += 1
            name = "UserImage\(startPoint).jpg"
            imagePath = path
                .appendingPathComponent("userBackgroundImages")
                .appendingPathComponent(name)
#if DEBUG
            logManager.shared.logMessage("Images Count: \(backgroundImages.count)", .debug)
#endif
        }
        return true
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
    
    func saveImagesToLocalStorage(){
        if backgroundImages.count > 0 {
            storedImage = backgroundImages[0]
        } else {
            logManager.shared.logMessage("\(#line) No images to store", .warning)
            return
        }
        //convert backgroundImages to Data
        let dir_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("userBackgroundImages", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: dir_path.path) {
            do {
                try FileManager.default.createDirectory(atPath: dir_path.path, withIntermediateDirectories: true, attributes: nil)
#if DEBUG
                logManager.shared.logMessage("Created Directory: \(dir_path.absoluteString)", .debug)
#endif
            }
            catch{
                logManager.shared.logMessage("Error creating user directory \(error.localizedDescription)", .warning)
            }
        }
        
        var startPoint = 1
        var name = "UserImage\(startPoint).jpg"
        for userImage in backgroundImages {
            let img_dir = dir_path.appendingPathComponent(name)
#if DEBUG
            logManager.shared.logMessage("Saving file to path: \(img_dir.absoluteString)", .debug)
#endif
            do {
                try userImage.jpegData(compressionQuality: 50)?.write(to: img_dir)
//                #if DEBUG
//                logManager.shared.logMessage("Image saved to: \(img_dir.absoluteString)", .debug)
//                #endif
            }
            catch {
                logManager.shared.logMessage("Failed to save image err:"+error.localizedDescription, .warning)
            }
            startPoint+=1
            name = "UserImage\(startPoint).jpg"
        }
    }
}



#Preview {
    InitScreen()
//    InitScreen( mySoundPtr: InitScreen.Sounds(CorrectAnswer: nil, NextLevel: nil, WrongAnswer: nil))
}
