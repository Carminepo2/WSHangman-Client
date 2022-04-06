//
//  File.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 25/03/22.
//

import Foundation
import UIKit

protocol WSHangmanGameDelegate {
    func didReceiveGameStateResponse(_ message: WSGameState)
    func didConnectionStopped()
}

class WSHangmanGame: WebSocketStream {
    
    let player: Player
    
    init(player: Player) {
        self.player = player
        
        var wsUrlComponents = URLComponents()
        wsUrlComponents.scheme = "wss"
        wsUrlComponents.host = Settings.wsHost
        wsUrlComponents.path = Settings.wsPath
        wsUrlComponents.queryItems = [
            URLQueryItem(name: "playerId", value: player.id),
            URLQueryItem(name: "username", value: player.username),
        ]
        
        super.init(url: wsUrlComponents.url!)
        self.startListeningForGuesses()
    }
    
    var delegate: WSHangmanGameDelegate?
    private lazy var throttler = Limiter(policy: .throttle, duration: Settings.throttleDuration)
    
    func startListeningForGuesses() {
        self.ping()
        Task {
            do {
                for try await message in self {
                    switch message {
                    case .data(let response):
                        guard let gameStateResponse = try? JSONDecoder().decode(WSGameState.self, from: response) else { return }
                        print(gameStateResponse)
                        DispatchQueue.main.async {
                            self.delegate?.didReceiveGameStateResponse(gameStateResponse)
                        }
                    default:
                        fatalError("Wrong response from the server: \(message)")
                    }
                    
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didConnectionStopped()
                }
            }
        }
    }
    
    func submitGuess(_ guess: String) {
        Task {
            await throttler.submit {
                await self.sendMessage(
                    data: WSPlayerGuess(playerId: UUID(uuidString: self.player.id)!, guess: guess)
                )
            }
        }
    }
    
    struct Player: Identifiable, Codable {
        var id: String
        var username: String
    }
}
