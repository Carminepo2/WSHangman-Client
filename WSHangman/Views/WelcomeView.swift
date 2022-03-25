//
//  WelcomeView.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 25/03/22.
//

import SwiftUI

struct WelcomeView: View {
    @State private var username = ""
    
    var body: some View {
        VStack {
            
            Text("WSHangmanGame")
                .font(.title)
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .frame(width: UIScreen.main.bounds.width / 1.6)
                .padding(.vertical)

            
            Button("Start", action: setAuthentication)
                .buttonStyle(.borderedProminent)

        }
    }
    
    
    //MARK: - User Intents
    func setAuthentication() {
        UserDefaults.standard.set(
            username,
            forKey: Settings.userDefaultsUsernameKey
        )
        
        UserDefaults.standard.set(
            UUID().uuidString,
            forKey: Settings.userDefaultsIdKey
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
