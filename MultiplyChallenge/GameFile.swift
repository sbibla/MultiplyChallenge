//
//  GamificationView.swift
//  LBTAFireBaseChat
//
//  Created by Saar Bibla on 2/15/24.
//

import SwiftUI
//import Firebase
//import FirebaseStorage
import AudioToolbox
import AVFoundation





struct GameFile: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var sound = false

    @State var localBackgroundImage: [UIImage?] = [UIImage(named: "DefaultImage1.heic"), UIImage(named: "DefaultImage2.heic"), UIImage(named: "DefaultImage3.heic"), UIImage(named: "DefaultImage4.heic"), UIImage(named: "DefaultImage5.jpeg"), UIImage(named: "DefaultImage6.heic"), UIImage(named: "DefaultImage7.jpeg"), UIImage(named: "DefaultImage8.heic"), UIImage(named: "DefaultImage9.heic"), UIImage(named: "DefaultImage10.jpeg")]
    @State private var showImage = [false, false, false, false,
                                    false, false, false, false,
                                    false, false, false, false,
                                    false, false, false, false]
    @State private var disableButton = [false, false, false, false,
                                        false, false, false, false,
                                        false, false, false, false,
                                        false, false, false, false]
    
    @Environment(\.dismiss) var dismiss
    @State var initmathDictionary = ["1+1=?", "1+2=?","1+3=?", "1+4=?",
                                     "2+1=?", "2+2=?", "2+3=?", "2+4=?",
                                     "3+1=?", "3+2=?", "3+3=?", "3+4=?",
                                     "4+1=?", "4+2=?", "4+3=?", "4+4=?"]
    @State private var pmathDictionary: [String: (Int, Int, Int, Int)] = [:]
    @State var currentEquation = "Press to Start!"
    @State var displayStartGameButton = true
    #warning("Change to true before publish")
    @State var currentEquationAnswers = ["Ans1", "Ans2", "Ans3"]
    @State var currentButton = 0
    @State var levelComplete = true
    @State private var dbStatusMessage = ""
    @State var mistakesInLevel = 0
    @State private var puzzlePickedImage: UIImage?
    @State var gameBackgroundImagesDictionary: [Int: UIImage] = [:]
    @State var shouldShowImagePicker = false
    @State var currentLevel = 1
    @State var disalbeAnswerButtonsUntilNextQuestion = false
    @State private var hasTimeElapsed = false


//    @State private var pressed = false
//    class UserData: ObservableObject {
//        @Published var username: String = "John"
//    }



    struct MyButtonStyle: PrimitiveButtonStyle {
        var color: Color
        var col, row: Int

        func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
            MyButton(configuration: configuration, color: color, col: col, row: row)
        }

        struct MyButton: View {
            @State private var pressed = false
            let configuration: PrimitiveButtonStyle.Configuration
            let color: Color
            let col: Int
            let row: Int

            var body: some View {

                return configuration.label
                    .foregroundColor(.white)
    //                .padding(15)
                    .background(RoundedRectangle(cornerRadius: 1).fill(color))
                    .compositingGroup()
                    .shadow(color: .black, radius: 3)
                    .opacity(self.pressed ? 0.8 : 1.0)
                    .scaleEffect(self.pressed ? 0.9 : 1.0)
                    .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 1)) {
                        self.pressed = pressing
//                        print("call: \(GamificationView().environmentObject(UserData().username))")
                    }
//                    if pressing {
//                            print("col: \(col)")
//
//                    } else {
//                        print("My long pressed ends")
//
//                    }
                }, perform: { })
            }
        }
    }
    let encouragementTextArray = ["👋🏼 כל הכבוד 👋🏼","Good Job 💪🏼","Bravo 👋🏼", "Excellent 🌈", "Perfecto ⚡️", "Respect!! 😎", "Nice 💯", "Good On'ya 💪🏼", "That is right! 🍭", "Bullseye 🎯", "Ready for more ❔", "Correct Answer 👍🏽", "🎉 Amazing 🎉", "Keep Pushing 🫸🏼", "👩‍👦‍👦🤞👨", "🧑👈🙏💪", "😔👈🏋🥇"]
//    @EnvironmentObject var userData: UserData
    var body: some View {
        ZStack {
            Image(uiImage: localBackgroundImage[currentLevel-1]!)
                .resizable()
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .aspectRatio(contentMode: .fit)
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            VStack(spacing: 1) {
                //            Spacer()
                ForEach(0..<4) {row in
                    HStack(spacing: 1) {
                        //                    Spacer()
                        ForEach(0..<4) { col in
                            Button {
                                currentButton = col+4*row
//                                userData.username = "saar"
                                currentEquation = initmathDictionary[currentButton]
                                populateAnswers()
                            } label: {
                                Text(self.showImage[col+4*row] ? "" : initmathDictionary[col+4*row])
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                                    .background(self.showImage[col+4*row] ? Color.clear : .indigo)
                                    .tag("\(col+4*row)")
                            }
                            .disabled(disableButton[col+4*row])
//                            .buttonStyle(MyButtonStyle(color: .clear, col: col, row: row))
                            
                            #warning("Hide the background of the button when pressed (non-clear)")

                        }
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.5)
                    }.ignoresSafeArea()
                }
                            Spacer()
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .background(.black)
                    .opacity(0.9)
            }
            .overlay(
                showAnswerButtons, alignment: .bottom)
            .navigationBarHidden(true)
            .overlay(displayStartGameButton ? startGameButton : nil, alignment: .center )
//            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil, content: {
//                ImagePicker(image: $puzzlePickedImage)
//            })
//            Image(levelComplete&&(!displayStartGameButton) ? "EngFlowChart" : "").aspectRatio(contentMode: .fit)
        }
    }
    
//    private func initDictionary()    {
//        for num in (0..<16) {
//            pmathDictionary[initmathDictionary[num]] = (-1,-1,-1,-1)
//        }
//    }
//
    func playSounds(_ soundFileName : String) {
        if sound == false {             // Have a toggle to mute sound in app
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
        }
    }
    private func buildLevel(level: Int) {
        var resultOne, resultTwo, resultThree, resultLocation: Int
        var equation = ""
        mistakesInLevel = 0
        pmathDictionary.removeAll()
        print("Starting new game, pmathSize:\(pmathDictionary.count)")
        
//        building dictionary until reaches 16 questions. Looping to remove duplicate keys
        while pmathDictionary.count < 16 {
            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateMultiplicationEquation(10)
            print("Inserting to pmath:\(equation), \(resultOne), \(resultTwo), \(resultThree), \(resultLocation)")
            if (pmathDictionary.updateValue((resultOne, resultTwo, resultThree, resultLocation), forKey: equation) != nil) {
                print("value \(equation) already exists")
            }
        }
        print("Dictionary built with size \(pmathDictionary.count)")
        initLevelButtons()

        for img in gameBackgroundImagesDictionary {
            localBackgroundImage.append(img.value)
        }
        print("Filled background images with size of \(localBackgroundImage.count)")
        
    }
    private func initLevelButtons() {
        for count in 0...15 {
            disableButton[count] = false
            showImage[count] = false
        }
    }
    private func startGame(){
        displayStartGameButton = false
        levelComplete.toggle()
        buildLevel(level: currentLevel)
        populateQuestions()
        for eq in pmathDictionary {
            print("Equation \(eq.key) answers: \(eq.value) correct: \(eq.value.3)")
        }
        print("size: \(pmathDictionary.count)")
    }
    private func populateQuestions(){
        var keyNumber = 0
        print("Inserting to initmathDict \(pmathDictionary.count)")
        for eq in pmathDictionary {
            if keyNumber > 15 {
                perror("Too many elements in dictionary \(pmathDictionary.count)")
                return}

            initmathDictionary[keyNumber] = eq.key
//            initmathDictionary.append(eq.key)
            keyNumber+=1
            #warning("Hardcoded keyNumber will cause index out of range")
        }
    }
    func populateAnswers(){
        currentEquationAnswers[0] = String(pmathDictionary[currentEquation]?.0 ?? -1)
        currentEquationAnswers[1] = String(pmathDictionary[currentEquation]?.1 ?? -1)
        currentEquationAnswers[2] = String(pmathDictionary[currentEquation]?.2 ?? -1)
        disalbeAnswerButtonsUntilNextQuestion = false
    }
    private var startGameButton: some View {
        
        HStack(spacing: 16) {
            VStack {
                Button {
                    startGame()
                    //            dismiss()
                }label: {
                    Text("Start game 🕺🏻")
                        .font(.system(size: 122, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(.black)
                }
            }
        }
    }
                   
    struct showImageWithDelay: View {
        @State private var hasTimeElapsed = false

        var body: some View {
            Text(hasTimeElapsed ? "Sorry, too late." : "Please enter above.")
                .task(delayText)
        }

        private func delayText() async {
            // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
            try? await Task.sleep(nanoseconds: 7_500_000_000)
            hasTimeElapsed = true
        }
    }
    
    private func delayLevel() async {
        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
        try? await Task.sleep(nanoseconds: 7_500_000_000)
//        hasTimeElapsed = true
        buildLevel(level: currentLevel)
    }
    private var showAnswerButtons: some View {
        VStack {
            Button {
            } label: {
                HStack {
                    Spacer()
                    Text(disalbeAnswerButtonsUntilNextQuestion ? encouragementTextArray[Int.random(in:0 ... encouragementTextArray.count-1)] : currentEquation)
                        .font(.system(size: 26, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color.orange)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)

            }
            HStack {
                Button {
                    checkAnswer(userAnswered: 0)
                } label: {
                    HStack {
                        Spacer()
                        Text(self.currentEquationAnswers[0])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disalbeAnswerButtonsUntilNextQuestion)
                Button {
                    checkAnswer(userAnswered: 1)
                } label: {
                    HStack {
                        Spacer()
                        Text(currentEquationAnswers[1])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disalbeAnswerButtonsUntilNextQuestion)
                Button {
                    checkAnswer(userAnswered: 2)
                } label: {
                    HStack {
                        Spacer()
                        Text(currentEquationAnswers[2])
                            .font(.system(size: 16, weight: .bold))
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .background(Color.gray)
                    .cornerRadius(32)
                    
                    .padding(.horizontal)
                    .shadow(radius: 15)
                }.disabled(disalbeAnswerButtonsUntilNextQuestion)
            }
        }
}
    private func checkAnswer(userAnswered: Int){
        if userAnswered == pmathDictionary[currentEquation]?.3 {
            correctAnswer()
        } else {
            wrongAnswer()
        }
    }
    private func wrongAnswer() {
//        AudioServicesPlaySystemSound(SystemSoundID(1000))
        mistakesInLevel += 1
        playSounds("WrongAnswer.aiff")

    }
    private func correctAnswer() {
        print("Answered correctly")
        playSounds("CorrectAnswer.wav")
        showImage[currentButton].toggle()
        disableButton[currentButton].toggle()
        disalbeAnswerButtonsUntilNextQuestion.toggle()
        #warning("Disable answer button until another question is being pressed")
        
        //All answers are correct
        if disableButton.allSatisfy({$0}) {
            levelComplete.toggle()
            print("Level completed with \(mistakesInLevel) mistakes")
            if mistakesInLevel < 5 {
                print("Advancing to next level")
                playSounds("NextLevel.aiff")
                currentLevel += 1
            }else {
                print("Too many mistakes, repeat level")
                playSounds("RepeatLevel.aiff")
            }
//            announceLevelWinner()
//            writeLevelFinishTime()

            DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {startGame()})
        }
        
        
    }
    private func announceLevelWinner() {
        
    }
    
    private func loadUserImagesFromStorage() {
//        let testImage: UIImage
//        List {
//            ForEach(Array(dict.keys), id: \.self) { key in
//                Section(header: Text(key)) {
//                    Text(dict[key] ?? "")
//                }
//            }
    }
    
    private func writeLevelFinishTime(){
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
//        else {return}
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        let dateString = formatter.string(from: date)
//        print(dateString)
//        
//
//        let userData = ["uid": uid, "LevelFinishTime" : dateString]
//
//        FirebaseManager.shared.firestore.collection("Arena")
//            .document(/*uid*/"game1").updateData(userData) { err in
//                if let err = err {
//                    print(err)
//                    self.dbStatusMessage = "\(err)"
//                    return
//                }
//                print("Success")
//                
//
//            }
    }
}

#Preview {
    GameFile()
}
