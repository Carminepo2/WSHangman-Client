//
//  WSGameState.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 25/03/22.
//

import Foundation

struct WSGameState: Decodable {
    let wordToGuess: Array<String?>
    let triesRemaining: UInt8
    let lastGuess: String?
}
