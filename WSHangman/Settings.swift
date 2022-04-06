//
//  Settings.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 25/03/22.
//

import Foundation


struct Settings {
    static let userDefaultsIdKey = "id"
    static let userDefaultsUsernameKey = "username"
    
    static let throttleDuration = 0.5
    
    static let wsHost = "ws-hangman-game.herokuapp.com"
    static let wsPath = "/start"
}
