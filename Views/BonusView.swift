//
//  BonusView.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 2/20/24.
//

import SwiftUI

struct BonusView: View {
    
    @State private var equation1: String = "3*5"
    @State private var equation2: String = "4*10"
    @State private var answer: Int = 0
    @State private var score: Int = 0
    @State private var timeRemaining: Double = 60.0
    @State private var isGameOver: Bool = false

    let timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()

    var body: some View {
        ZStack {
            Image("spaceImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            VStack {
                HStack {
                    Text(equation1)
                        .font(.system(size: 40))
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    Button("Bigger!") {
                        checkAnswer(number: 1)
                    }
                }
                HStack {
                    Text(equation2)
                        .font(.system(size: 40))
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    Button("Bigger!") {
                        checkAnswer(number: 2)
                    }
                }
                HStack {
                    Text("Score: \(score)")
                    Text("Time: \(Int(timeRemaining))")
                }.foregroundColor(.red)
                if isGameOver {
                    Text("Game Over! Score: \(score)")
                        .font(.title)
                    Button("Play Again") {
                        resetGame()
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
            isGameOver = true
          }
        }
      }

      func generateEquations() {
        // Generate random equations with difficulty levels
        // ... replace with your logic for generating equations
          while equation1 == equation2
          {
              equation1 = "\(Int.random(in:1 ... 12))* \(Int.random(in:1 ... 12))"
              equation2 = "\(Int.random(in:1 ... 12))* \(Int.random(in:1 ... 12))"
          }
        answer = calculateProduct(equation1) > calculateProduct(equation2) ? 1 : 2
      }

      func calculateProduct(_ equation: String) -> Int {
        // Extract numbers from the equation and calculate product
        // ... replace with your logic for extracting numbers and calculating product
          return 1
      }

      func checkAnswer(number: Int) {
        if number == answer {
          score += 1
        } else {
          score -= 1
            if score < 0 { 
                score = 0
                timeRemaining -= 1
            }
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
    BonusView()
//    MultiplicationComparisonView()
}


