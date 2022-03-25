//
//  WSMessage.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import Foundation

struct WSMessage: Codable {
    var date = Date()
    let text: String
    let user: String
}
