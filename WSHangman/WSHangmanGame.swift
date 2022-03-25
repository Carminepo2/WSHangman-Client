//
//  File.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 25/03/22.
//

import Foundation
import UIKit

class WSHangmanGame: WebSocketStream {
    
    private(set) var guesses = Array<String>()
    var connectionError = false
    let player: Player
    
    
    init(player: Player) {
        self.player = player
        
        var wsUrlComponents = URLComponents()
        wsUrlComponents.scheme = "wss"
        wsUrlComponents.host = "last-word-wins-backend.herokuapp.com"
        wsUrlComponents.path = "/start"
        wsUrlComponents.queryItems = [
            URLQueryItem(name: "playerId", value: player.id),
        ]
        
        super.init(url: wsUrlComponents.url!)
        self.startListeningForGuesses()
    }
    
    private lazy var throttler = Limiter(policy: .throttle, duration: 2)
    
    func startListeningForGuesses() {
        self.ping()
        Task {
            do {
                for try await message in self {
                    switch message {
                    case .data(let messageData):
                        
                        guard let decodedWinner = try? JSONDecoder().decode(WSMessage.self, from: messageData) else { return }
                        self.guesses.append("Test")
                        
                    default:
                        fatalError("Wrong response from the server: \(message)")
                    }
                    
                }
            } catch {
                connectionError = true
            }
        }
    }
    
    func submitGuess(_ guess: String) {
        Task {
            await throttler.submit {
                await self.sendMessage(
                    data: WSMessage(text: guess, user: "Pippo")
                )
            }
        }
    }
    
    
    struct Player: Identifiable, Codable {
        var id: String
        var username: String
    }
}
