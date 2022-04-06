//
//  WSHangmanGameViewModel.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import Foundation
import SwiftUI

class WSHangmanGameViewModel: ObservableObject, WSHangmanGameDelegate {
    @Published var wsHangmanGame: WSHangmanGame!
    
    @Published var lastGuesses = Array<String>()
    @Published var wsGameState: WSGameState?
    @Published var guess = ""
    @Published var connectionError = false
    
    init() {
        self.wsHangmanGame = WSHangmanGameViewModel.createWSHangmanGame()
        self.wsHangmanGame.delegate = self
    }
    
    static func createWSHangmanGame() -> WSHangmanGame {
        let id = UserDefaults.standard.string(forKey: "id")
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let id = id,
           let username = username {
            return WSHangmanGame(player: .init(id: id, username: username))
        } else {
            fatalError("Not authenticated")
        }
    }
    
}

// MARK: - User Intents
extension WSHangmanGameViewModel {
    func sendGuess() {
        guard wsGameState?.wordToGuess.count == self.guess.count else { return }
        
        wsHangmanGame.submitGuess(self.guess.lowercased())
        self.guess = ""
    }
}


// MARK: - Delegate Functions
extension WSHangmanGameViewModel {
    func didReceiveGameStateResponse(_ message: WSGameState) {
        self.wsGameState = message
        
        withAnimation {
            if lastGuesses.count > 3 {
                lastGuesses.removeLast()
            }
            
            if let lastGuess = message.lastGuess {
                lastGuesses.insert(lastGuess, at: 0)
            }
        }
    }
    
    func didConnectionStopped() {
        connectionError = true
    }
}


