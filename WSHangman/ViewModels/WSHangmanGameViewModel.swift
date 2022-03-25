//
//  WSHangmanGameViewModel.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import Foundation

class WSHangmanGameViewModel: ObservableObject {
    @Published var currentWinner: WSMessage? = nil
    @Published var guess = ""
    @Published var connectionError = false
    @Published var wsHangmanGame = createWSHangmanGame()
    
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
    
    
    // MARK: - User Intents
    func sendGuess() {
        wsHangmanGame.submitGuess("Try")
    }
    
}
