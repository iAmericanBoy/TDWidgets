//
//  ContentView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 11/5/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OAuthView(viewModel: OAuthViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
