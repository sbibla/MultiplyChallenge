//
//  BonusView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/20/24.
//

import SwiftUI
import AudioToolbox
import AVFoundation

#warning("Improvements to follow")
/*
 After user chooses, show the old score animated flying upwards (so the user can see the last question)
 At the end of the level a clearer message that the level ended and CTA "press xyz..."
 beeps in last 5sec of bonus level
 */
struct BonusView: View {
    

    
    @State private var literal1: Int = 11
    @State private var literal2: Int = 6
    @State private var literal3: Int = 10
    @State private var literal4: Int = 8
    @State private var answer: Int = 0
    @State private var score: Int = 0
    
    @State private var timeRemaining: Double = 65.0
    @State private var delayStartTimeRemaining: Double = 5
    @State private var resultDisplayTime: Double = 1
    @State private var isGameOver: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @State var sound = false
    @State var answerLabel: String?
    @State var showBonusIntro = true
    @Binding var isPresented: Bool
    @Binding var highScore: Int
    @Environment(\.presentationMode) var presentationMode

    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    let delayStartTimer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    let resultDisplayTimer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Image("spaceImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("Which is Bigger")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                    .mask(
                                   LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                               )
                Text("Highest Score \(highScore)")
                    .font(.system(size: 20))
                    .foregroundColor(.red)
                    .opacity(0.8)
                Spacer()
//                VStack {
                    HStack(spacing: 40) {
                        HStack {
                            Button() {
                                checkAnswer(number: 1)
                            }label: {
                                VStack(alignment: .trailing) {
                                    Text("\(literal1)")
                                        .font(.system(size: 40))
                                    
                                    Text("x \(literal2)")
                                        .font(.system(size: 40))
                                        .underline()
                          
                                    Image("Bigger")
                                        .resizable()
                                        .frame(width: 80, height: 50)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                        .mask(
                                                       LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                                   )

//
                                }
                            }.disabled(isGameOver)
                        }
//                                                Text(">\n<\n=")
//                                                    .font(.system(size: 20))
//                        Divider()
                        Text(answerLabel ?? "Touch the\nBigger")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 25))
                        
                        HStack {
                            Button(){
                                checkAnswer(number: 2)
                            }label: {
                                
                                VStack(alignment: .trailing) {
                                    Text("\(literal3)")
                                        .multilineTextAlignment(.trailing)
                                        .font(.system(size: 40 ))
                                    
                                    Text("x \(literal4)")
                                        .multilineTextAlignment(.trailing)
                                        .font(.system(size: 40))
                                    //                            .offset(y: -5)
                                        .underline()
                                    Image("Bigger")
                                        .resizable()
                                        .frame(width: 80, height: 50)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                        .mask(
                                                       LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                                   )
                                }
                            }.disabled(isGameOver)
                        }
                    }.foregroundColor(.white)
                Spacer()
                HStack {
                    Text("Score: \(score)")
                        .font(.system(size: 20))
                    Text("Time: \(Int(timeRemaining))")
                        .font(.system(size: 20))
                }.foregroundColor(.red)
                if isGameOver {
                    Text("Game Over! Score: \(score)")
                        .font(.title)
                    Text("Highest Score \(highScore)")
                    Button("Return to Game") {
                        isPresented.toggle()
                    }
                }
            }
        }
        .onAppear {
            generateEquations()
//            loadHighScoreData()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if score > highScore {
                    #warning("Refactor to use the userDataModelView")
                    highScore = score
                    writeHighScoreData(data: highScore, Key: "highScore")
                }
                isGameOver = true
            }
        }
        .onReceive(resultDisplayTimer) { _ in
            if resultDisplayTime > 0 {
                resultDisplayTime -= 1
            }else {
                answerLabel = nil
                
            }
        }
        .onReceive(delayStartTimer) { _ in
            if delayStartTimeRemaining > 1 {
                delayStartTimeRemaining -= 1
            }else {
//                timeRemaining = 60
                showBonusIntro = false
            }
        }
        .overlay(showBonusIntro ? BonusIntroScreen : nil, alignment: .center )
    }
    
    private var BonusIntroScreen: some View {
        HStack(spacing: 16) {
            VStack {
                Button {
                    timeRemaining = 60.0
                    showBonusIntro.toggle()                    
                }label: {
                    Text("Bonus Level\n Starts in\n\(Int(delayStartTimeRemaining))")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(.black)
                }
            }
        }
    }
    func writeHighScoreData(data: Int, Key: String) {
        UserDefaults.standard.set(data, forKey: Key)
        logManager.shared.logMessage("High-score \(data.description) saved locally", .debug)
    }
//    func loadHighScoreData(){
//        let savedScore = UserDefaults.standard.integer(forKey: "highScore")
//        if (savedScore == 0) {
//            highScore = 0
//            logManager.shared.logMessage("No saved highScore", .warning)
//        } else {
//            highScore = savedScore
//            logManager.shared.logMessage("Found high score value: \(savedScore)", .info)
//        }
//    }
    func generateEquations() {
        // Generate random equations with difficulty levels
        // ... replace with your logic for generating equations
        repeat {
            literal1 = Int.random(in:1 ... 12)
            literal2 = Int.random(in:1 ... 12)
            literal3 = Int.random(in:1 ... 12)
            literal4 = Int.random(in:1 ... 12)
        } while literal1*literal2 == literal3*literal4

        answer = literal1*literal2 > literal3*literal4 ? 1 : 2
    }
    
    func playSounds(_ soundFileName : String) {
        if sound == false {             // Have a toggle to mute sound in app
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
    
    func checkAnswer(number: Int) {
        if number == answer {
            score += 1
            answerLabel = "👍🏼"
            playSounds("CorrectAnswer.wav")
            resultDisplayTime = 1.2
        } else {
            score -= 1
            answerLabel = "👎🏻"
            playSounds("WrongAnswer.aiff")
            if score < 0 {
                score = 0
            }
            timeRemaining -= 10
            resultDisplayTime = 1.2
        }
        generateEquations()
        //        timeRemaining = 60.0
    }
    
    func resetGame() {
        score = 0
        timeRemaining = 60.0
        isGameOver = false
        generateEquations()
    }
    
}

#Preview {
//    BonusView(isPresented: $0, highScore: $1)
    BonusView(isPresented: .constant(true), highScore: .constant(13))
//    BonusView2()
    //    MultiplicationComparisonView()
}

struct BonusView2: View {
    var body: some View {
        ZStack {
            Image("spaceImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            HStack {
                
                Image("Bigger")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
//                    .mask(
//                                   LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
//                               )
                
                Image("Bigger")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            }
        }
        
    }
}

