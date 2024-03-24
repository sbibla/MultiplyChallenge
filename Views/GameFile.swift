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
    @State var localBackgroundImage: [UIImage]
//    init(img: [UIImage]) {
//        for myImg in img {
//            self.localBackgroundImage.append(myImg)
//        }
//        startGame()
//    }
//    init(localBackgroundImage: [UIImage?] = [nil]){
//        _localBackgroundImage = State(initialValue: localBackgroundImage)
//        _puzzlePickedImage =  State(initialValue: puzzlePickedImage)
//    }
    
    @State var audioPlayer: AVAudioPlayer!
    @State var soundsMuted = false

  
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
    
//    @State var initmathDictionary: [String] = []
    
    @State private var pmathDictionary: [String: (Int, Int, Int, Int)] = [:]
    @State var currentEquation = "Level 1"
    @State var displayStartGameButton = true
    @State var currentEquationAnswers = ["Ans1", "Ans2", "Ans3"]
    @State var currentButton = 0
    @State var levelComplete = false
    @State var soundsInitialized = false
    @State private var dbStatusMessage = ""
    @State var mistakesInLevel = 0
    @State private var puzzlePickedImage: UIImage?
    @State var gameBackgroundImagesDictionary: [Int: UIImage] = [:]
    @State var shouldShowImagePicker = false
    @State var currentLevel = 1
    @State var disalbeAnswerButtonsUntilNextQuestion = false
    @State private var hasTimeElapsed = false
    @State private var testMode = false
    @State var advanceToNextLevel = false
    @State private var allTilesDisabled = false
    @State private var isPresented = false
    @State var startBonusLevel = false
    @State var highScore: Int
    @State var CorrectAnswer: URL? = nil
    @State var NextLevel: URL? = nil
    @State var RepeatLevel: URL? = nil
    @State var Bonus: URL? = nil
    @State var WrongAnswer: URL? = nil
    
    @Environment(\.presentationMode) var presentationMode



    let encouragementTextArray = ["👋🏼 כל הכבוד 👋🏼","Good Job 💪🏼","Bravo 👋🏼", "Excellent 🌈", "Perfecto ⚡️", "Respect!! 😎", "Nice 💯", "Good On'ya 💪🏼", "That is right! 🍭", "Bullseye 🎯", "Ready for more ❔", "Correct Answer 👍🏽", "🎉 Amazing 🎉", "Keep Pushing 🫸🏼", "👩‍👦‍👦🤞👨", "🧑👈🙏💪", "😔👈🏋🥇", "Very good🕺🏻"]
//    @EnvironmentObject var userData: UserData

    var body: some View {
        ZStack {
            BackgroundPuzzleImage
            VStack{
                Text("Level \(currentLevel)")
                    .bold()
                Spacer()
            }
            VStack(spacing: 1) {
                QuestionButtons
                Spacer()
                    .frame(minWidth: 100, maxWidth: .infinity)
                    .background(.black)
                    .opacity(0.9)
            }
            .overlay(
                showAnswerButtons, alignment: .bottom)
            .navigationBarHidden(true)
            .overlay(displayStartGameButton ? startGameButton : nil, alignment: .center )
            .fullScreenCover(isPresented: $isPresented, content: {
                BonusView(isPresented: $isPresented, highScore: $highScore)
            })
        }
    }
    
    var QuestionButtons: some View {
        ForEach(0..<4) {row in
            HStack(spacing: 1) {
                //                    Spacer()
                ForEach(0..<4) { col in
                    Button {
                        currentButton = col+4*row
                        //                                userData.username = "saar"
                        currentEquation = (levelComplete ? "Advancing to level \(currentLevel)" : initmathDictionary[currentButton])
                        populateAnswers()
                    } label: {
                        Text(self.showImage[col+4*row] ? "" : initmathDictionary[col+4*row])
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .background(self.showImage[col+4*row] ? Color.clear : .indigo)
                            .tag("\(col+4*row)")
                    }
                    .disabled(disableButton[col+4*row] || allTilesDisabled)
#warning("Hide the background of the button when pressed (non-clear)")
                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.5)
            }.ignoresSafeArea()
        }
    }
    var BackgroundPuzzleImage: some View {
        Image(uiImage: localBackgroundImage.count <= (currentLevel-1) ? UIImage(named: "Loading.jpg")! : localBackgroundImage[currentLevel-1])
            .resizable()
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .aspectRatio(contentMode: .fit)
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
//    private func initDictionary()    {
//        for num in (0..<16) {
//            pmathDictionary[initmathDictionary[num]] = (-1,-1,-1,-1)
//        }
//    }
//
    func initSounds(){
        logManager.shared.logMessage("Initializing sounds", .debug)
        CorrectAnswer = Bundle.main.url(forResource: "CorrectAnswer.wav", withExtension: nil)
        if CorrectAnswer == nil { fatalError("Unable to find CorrrectAnswer.wav in bundle") }
        
        NextLevel = Bundle.main.url(forResource: "NextLevel.aiff", withExtension: nil)
        if NextLevel == nil {    fatalError("Unable to find NextLevel.aiff in bundle") }
        
        RepeatLevel = Bundle.main.url(forResource: "RepeatLevel.aiff", withExtension: nil)
        if RepeatLevel == nil { fatalError("Unable to find RepeatLevel.aiff in bundle") }
        
        Bonus = Bundle.main.url(forResource: "Bonus.wav", withExtension: nil)
        if Bonus == nil { fatalError("Unable to find Bonus.wav in bundle") }
        
        WrongAnswer = Bundle.main.url(forResource: "WrongAnswer.aiff", withExtension: nil)
        if WrongAnswer == nil { fatalError("Unable to find WrongAnswer.aiff in bundle") }
    }
    
    func playSounds(_ soundURL: URL){
        if soundsMuted == true {
            return
        }else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                logManager.shared.logMessage(error.localizedDescription, .warning)
            }
            audioPlayer.play()
        }
    }
    
    func playSounds(_ soundFileName : String) {
        if soundsMuted == true {             // Have a toggle to mute sound in app
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                logManager.shared.logMessage(error.localizedDescription, .warning)
            }
            audioPlayer.play()
        }
    }
    
    private func buildLevel(level: Int) {
        var resultOne, resultTwo, resultThree, resultLocation: Int
        var equation = ""
        mistakesInLevel = 0
        pmathDictionary.removeAll()
        logManager.shared.logMessage("Starting new game, pmathSize:\(pmathDictionary.count)", .debug)
        
//        building dictionary until reaches 16 questions. Looping to remove duplicate keys
        while pmathDictionary.count < 16 {
            (equation, resultOne, resultTwo, resultThree, resultLocation) = MathQuestionBuilder.shared.generateMultiplicationEquation(10)
                logManager.shared.logMessage("Inserting to pmath:\(equation), \(resultOne), \(resultTwo), \(resultThree), \(resultLocation)", .debug)
            
            if (pmathDictionary.updateValue((resultOne, resultTwo, resultThree, resultLocation), forKey: equation) != nil) {
                logManager.shared.logMessage("value \(equation) already exists", .debug)
            }
        }
        logManager.shared.logMessage("Dictionary built with size \(pmathDictionary.count)", .debug )
        initLevelButtons()
        advanceToNextLevel = false
    }
    private func initLevelButtons() {
        for count in 0...15 {
            disableButton[count] = false
            showImage[count] = false
        }
    }
    private func startGame(){
        displayStartGameButton = false
        levelComplete = false
        buildLevel(level: currentLevel)
        populateQuestions()
        if soundsInitialized == false {
            initSounds()
            soundsInitialized = true
        }
        
       
            for eq in pmathDictionary {
                logManager.shared.logMessage("Equation \(eq.key) answers: \(eq.value) correct: \(eq.value.3)", .debug)
        }
        logManager.shared.logMessage("Starting game with \(pmathDictionary.count) questions in each level \n Current level \(currentLevel   )", .info)
    }
    
    private func populateQuestions(){
        var keyNumber = 0
        
        initmathDictionary.removeAll()
        
        
        for eq in pmathDictionary {
            if keyNumber > 15 {
                perror("Too many elements in dictionary \(pmathDictionary.count)")
                return}

//            initmathDictionary[keyNumber] = eq.key
            initmathDictionary.append(eq.key)
            keyNumber+=1
//            #warning("Hardcoded keyNumber will cause index out of range")
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
#if DEBUG
                if !localBackgroundImage.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(localBackgroundImage, id: \.self) {image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity,maxHeight: 55)
                    .background(.black)
                }
#endif
                
                
                
                Button {
                    startGame()
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
            .simultaneousGesture(TapGesture(count: 3).onEnded {
                if(testMode) {
                    currentLevel += 1
                    print("NextLevel pressed")
                }else {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .buttonStyle(MyButtonStyle(color: .black))
//            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            HStack {
                Button {
                    checkAnswer(userAnswered: 0)
                } label: {
                    HStack {
                        Spacer()
                        Text(disalbeAnswerButtonsUntilNextQuestion ? "👍🏼" : self.currentEquationAnswers[0])
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
                        Text(disalbeAnswerButtonsUntilNextQuestion ? "👍🏼" : currentEquationAnswers[1])
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
                        Text(disalbeAnswerButtonsUntilNextQuestion ? "👍🏼" : currentEquationAnswers[2])
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
        if testMode == true {
            correctAnswer()
            return
        }
        if userAnswered == pmathDictionary[currentEquation]?.3 {
            correctAnswer()
        } else {
            wrongAnswer()
        }
    }
    private func wrongAnswer() {
        mistakesInLevel += 1
        playSounds(WrongAnswer!)

    }
    private func correctAnswer() {
        print("Answered correctly")
//        playSounds("CorrectAnswer.wav")
        playSounds(CorrectAnswer!)
        showImage[currentButton].toggle()
        disableButton[currentButton].toggle()
        disalbeAnswerButtonsUntilNextQuestion.toggle()
        
        //All answers are correct
        if disableButton.allSatisfy({$0}) {
            levelComplete = true
            print("Level completed with \(mistakesInLevel) mistakes")
            disalbeAnswerButtonsUntilNextQuestion = false
            if mistakesInLevel < 5 {
                advanceToNextLevel = true
                //check if Bonus level
                if (currentLevel % 3 == 0) {
                    playSounds(Bonus!)
//                    startBonusLevel.toggle()
                    isPresented.toggle()
                } else {
                
                    currentEquation = "Setting Level \(currentLevel+1)"
                    playSounds(NextLevel!)
                }
            }else {
                advanceToNextLevel = false
                print("Too many mistakes, repeat level")
                currentEquation = "Repeat Level \(currentLevel)"
                playSounds(RepeatLevel!)
            }
            
//            announceLevelWinner()
//            writeLevelFinishTime()

            DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
                if advanceToNextLevel == true {
                    currentLevel += 1
                }
                //                currentLevel += 1
                currentEquation = "Choose an equation"
                startGame()})
        }
        
        
    }
    private func announceLevelWinner() {
        
    }
    
    private func loadUserImagesFromStorage() {

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
    GameFile(localBackgroundImage: [UIImage(named: "DefaultImage10.jpg")!, UIImage(named: "Loading.jpg")!], highScore: 0)
}
