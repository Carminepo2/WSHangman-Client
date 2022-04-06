//
//  WSPlayerGuess.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import Foundation

struct WSPlayerGuess: Encodable {
    var playerId: UUID
    let guess: String
}
