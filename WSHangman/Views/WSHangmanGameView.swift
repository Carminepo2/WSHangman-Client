//
//  WSHangmanGameView.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//

import SwiftUI

struct WSHangmanGameView: View {
    @EnvironmentObject var viewModel: WSHangmanGameViewModel
    
    var body: some View {
        if !viewModel.wsHangmanGame.connectionError {
            VStack {
                Form {
                    Text(viewModel.currentWinner?.text ?? "Unknown")

                    TextField("Message", text: $viewModel.guess)
                    Button("Send", action: viewModel.sendGuess)
                        .disabled(viewModel.connectionError)
                }
            }
        } else {
            ConnectionErrorView()
        }
    }
}

struct WSHangmanGameView_Previews: PreviewProvider {
    static var previews: some View {
        WSHangmanGameView()
    }
}
