//
//  ConnectionErrorView.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 24/03/22.
//

import SwiftUI

struct ConnectionErrorView: View {
    
    @EnvironmentObject var viewModel: WSHangmanGameViewModel
    
    var body: some View {
        VStack {
            
            Image(systemName: "exclamationmark.icloud.fill")
                .font(.title)
                .foregroundStyle(.tertiary)
            
            Text("Connection Error.")
                .font(.headline)
            
            Text("Please restart the app.")
                .padding(.top)
                .foregroundStyle(.secondary)
        }
    }
}

struct ConnectionErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionErrorView()
    }
}
