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
        if !viewModel.connectionError {
            if let wsGameState = viewModel.wsGameState {
                VStack {
                    
                    Spacer()
                    
                    WordToGuessView(wordToGuess: wsGameState.wordToGuess)
                    
                    Spacer()
                    
                    LastGuessesView(lastGuesses: viewModel.lastGuesses)
                    
                    Spacer()
                    
                    TextField("Guess", text: $viewModel.guess)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .padding(.vertical)
                        .onChange(of: viewModel.guess) {
                            self.viewModel.guess = String($0.prefix(wsGameState.wordToGuess.count))
                        }
                        .onSubmit {
                            viewModel.sendGuess()
                        }
                    
                    Button("Send", action: viewModel.sendGuess)
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.connectionError)
                    
                }
                .padding()
            } else {
                ProgressView()
            }
            
        } else {
            ConnectionErrorView()
        }
    }
}

fileprivate struct WordToGuessView: View {
    @EnvironmentObject var viewModel: WSHangmanGameViewModel
    let wordToGuess: Array<String?>
    
    var body: some View {
        HStack {
            ForEach(Array(wordToGuess.enumerated()), id: \.element) { i, letter in
                card(letter: letter)
            }
        }
    }
    
    @ViewBuilder
    func card(letter: String?) -> some View {
        let card = RoundedRectangle(cornerRadius: 8)
        GeometryReader { geo in
            ZStack {
                card
                    .fill(letter != nil ? .quaternary : .tertiary)

                Text(letter ?? "__")
                    .font(.system(size: geo.size.width * 0.6))
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        
    }
}

fileprivate struct LastGuessesView: View {
    let lastGuesses: Array<String>
    
    var body: some View {
        VStack {
            ForEach(Array(lastGuesses.enumerated()), id: \.element) { index, guess in
                Text(guess)
                    .font(
                        index == 0 ? .title
                        : index == 1 ? .title2
                        : index == 2 ? .title3
                        : .footnote
                    )
                    .foregroundStyle(
                        index == 0 ? .primary
                        : index == 1 ? .secondary
                        : index == 2 ? .tertiary
                        : .quaternary
                    )
            }
        }
    }
}

struct WSHangmanGameView_Previews: PreviewProvider {
    static var previews: some View {
        WSHangmanGameView()
    }
}
