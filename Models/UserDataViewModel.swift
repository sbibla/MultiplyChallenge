//
//  UserDataViewModel.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 3/27/24.
//

import Foundation
final class UserDataViewModel: ObservableObject {
    @Published var highScore = 0
    @Published var highestLevel = 1
    
    init() {
        if ( loadLastLevel() > 3 ){
            loadHighScoreData()
        }else {
            logManager.shared.logMessage("Highest level <3, No need to search for bonus level highscore", .debug)
        }
        
    }
    private func loadHighScoreData(){
        let savedScore = UserDefaults.standard.integer(forKey: "highScore")
        if (savedScore == 0) {
            highScore = 0
            logManager.shared.logMessage("No saved highScore", .warning)
        } else {
            highScore = savedScore
            logManager.shared.logMessage("Found high score value: \(savedScore)", .info)
        }
    }
    
    private func loadLastLevel()->Int {
        let savedHighestLevel = UserDefaults.standard.integer(forKey: "highestLevel")
        if (savedHighestLevel == 0) {
            highestLevel = 1
            logManager.shared.logMessage("No recorded level, Running for the first time", .warning)
            writeUserData(data: 1, Key: "highestLevel")
            //record first time
            return -1
        } else {
            highestLevel = savedHighestLevel
            logManager.shared.logMessage("Found highest level value: \(highestLevel)", .info)
            return highestLevel
        }
    }
    func writeUserLevel(level: Int) {
        writeUserData(data: level, Key: "highestLevel")
    }
//    writeHighScoreData(data: highScore, Key: "highScore")
    private func writeUserData(data: Int, Key: String) {
        UserDefaults.standard.set(data, forKey: Key)
        logManager.shared.logMessage("Data: \(Key) with value \(data) saved locally", .debug)
    }
}

