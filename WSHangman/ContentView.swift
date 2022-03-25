//
//  ContentView.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Settings.userDefaultsUsernameKey) private var username = ""
    
//    init() {
//        UserDefaults.standard.removeObject(forKey: Settings.userDefaultsIdKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userDefaultsUsernameKey)
//    }

    var body: some View {
        if !username.isEmpty {
            WSHangmanGameView()
                .environmentObject(WSHangmanGameViewModel())
        } else {
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
