//
//  BonusView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/20/24.
//

import SwiftUI
import AudioToolbox
import AVFoundation

struct BonusView: View {
    

    
    @State private var literal1: Int = 11
    @State private var literal2: Int = 6
    @State private var literal3: Int = 10
    @State private var literal4: Int = 8
    @State private var answer: Int = 0
    @State private var score: Int = 0
    @State private var highScore: Int = 0
    @State private var timeRemaining: Double = 60.0
    @State private var isGameOver: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    @State var sound = false
    @State var answerLabel: String?
    @State var showBonusIntro = true
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode

    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
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
                    Text("Time: \(Int(timeRemaining))")
                }.foregroundColor(.red)
                if isGameOver {
                    Text("Game Over! Score: \(score)")
                        .font(.title)
                    Text("Highest Score \(highScore)")
                    Button("Return to Game") {
//                        resetGame()
//                        presentationMode.wrappedValue.dismiss()
                        isPresented.toggle()
                    }
                }
            }
        }
        .onAppear {
            generateEquations()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if score > highScore {
                    highScore = score
                }
                isGameOver = true
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
                    Text("Bonus Level\n Starts in:\n\(Int(timeRemaining))")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .background(.black)
                }
            }
        }
    }
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
                print(error.localizedDescription)
            }
            audioPlayer.play()
        }
    }
    
    func checkAnswer(number: Int) {
        if number == answer {
            score += 1
            answerLabel = "👍🏼"
            playSounds("CorrectAnswer.wav")
        } else {
            score -= 1
            answerLabel = "👎🏻"
            playSounds("WrongAnswer.aiff")
            if score < 0 {
                score = 0
            }
            timeRemaining -= 10
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
    BonusView2()
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

