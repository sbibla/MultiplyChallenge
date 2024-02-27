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
//    @State var backgroundImages: [UIImage] = []
    @State var emailAddress = ""
    @State var password = ""
    @State var withLoginOption = true
    @State var userHasPickedImages = false
    @State var tmpImage = UIImage(named: "Loading.jpg")!
    let gradient = LinearGradient(colors: [.red, .green],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
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
                
                PhotosPicker("Choose Images", selection: $photosPickerItems,maxSelectionCount: 20, selectionBehavior: .ordered, matching: .images)
                //                .foregroundColor(.black)
                LoginView(emailAddress: emailAddress, password: password)
                    .opacity(withLoginOption ? 1 : 0)
                Spacer()
                Button {
                    print("Starting game for user \(emailAddress)")
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
                    print("Calling load images func")
//                    startBonusLevel.toggle()
                    loadImagesFromLocalStorage()
                }label: {
                    Text("🕺🏻New here? \n Create An Account")
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor.systemBlue))
                }
                .padding()
                .fullScreenCover(isPresented: $startGame, content: {
                    GameFile(localBackgroundImage: backgroundImages)
                })
                .onChange(of: photosPickerItems) { _, _ in
                    Task {
                        await copyImagesToArray()
                        //                    saveImagesToLocalStorage()
                    }
                }
                .onAppear{
                    Task {
                        if loadImagesFromLocalStorage() == false {
                            #if DEBUG
                            print("⚙️ Running for the first time, load default images")
                            #endif
                            
                        }else {
                            #if DEBUG
                            print("⚙️ \(backgroundImages.count) Images successfully loaded from local storage")
                            #endif
                        }
                    }
                }
            }//.background(Color(UIColor.black)) //VStack
        }
    }
    
    func loadDefaultImages(){
        var startPoint = 1
        while backgroundImages.count < 13 {
            backgroundImages.append(UIImage(named: "DefaultImage\(startPoint).jpg")!)
            startPoint+=1
        }
        saveImagesToLocalStorage()
    }
    func copyImagesToArray() async  {
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
        if backgroundImages.count == 0 {
            print("Called for 2nd time, exiting")
            return
        }
        print("User picked \(backgroundImages.count) Images")
        var startPoint = backgroundImages.count+1
        while backgroundImages.count < 13 {
            backgroundImages.append(UIImage(named: "DefaultImage\(startPoint).jpg")!)
            startPoint+=1
        }
        saveImagesToLocalStorage()
        #warning("Saving files twice (2nd time is after photosPicketItems.removeAll()")
    }
    
    @State private var storedImage: UIImage?
    
    func loadUserData(){
        //loadLocalImages from Storage
        if loadImagesFromLocalStorage() == false {
            print("Using default Images")
        }
        //load highscore
        
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
                print("File \(imagePath.absoluteString) is missing, exiting")
                return false
            }
#if DEBUG
            print("⚙️ Image loaded \(imagePath.absoluteString)")
#endif
            tmpImage = UIImage(contentsOfFile: imagePath.path)!
            backgroundImages.append(tmpImage)
            startPoint += 1
            name = "UserImage\(startPoint).jpg"
            imagePath = path
                .appendingPathComponent("userBackgroundImages")
                .appendingPathComponent(name)
#if DEBUG
            print("⚙️ Images Count: \(backgroundImages.count)")
#endif
        }
        return true
    }
    
    func saveImagesToLocalStorage(){
        if backgroundImages.count > 0 {
            storedImage = backgroundImages[0]
        } else {
            print("No images to store")
            return
        }
        //convert backgroundImages to Data
        let dir_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("userBackgroundImages", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: dir_path.path) {
            do {
                try FileManager.default.createDirectory(atPath: dir_path.path, withIntermediateDirectories: true, attributes: nil)
#if DEBUG
                print("⚙️ Created Directory: \(dir_path.absoluteString)")
#endif
            }
            catch{
                print("Error creating user directory \(error.localizedDescription)")
            }
        }
        
        var startPoint = 1
        var name = "UserImage\(startPoint).jpg"
        for userImage in backgroundImages {
            let img_dir = dir_path.appendingPathComponent(name)
#if DEBUG
            print("⚙️ saving file to path: \(img_dir.absoluteString)")
#endif
            do {
                try userImage.jpegData(compressionQuality: 50)?.write(to: img_dir)
                #if DEBUG
                print("Image saved to: \(img_dir.absoluteString)")
                #endif
            }
            catch {
                print("Failed to save image err:"+error.localizedDescription)
            }
            startPoint+=1
            name = "UserImage\(startPoint).jpg"
        }
    }
}



#Preview {
    InitScreen()
}
