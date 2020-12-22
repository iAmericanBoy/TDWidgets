//
//  AccountView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import SwiftUI

struct AccountHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Margin Account")
                    .font(.headline)
                Spacer()
                Image(systemName: "star")
                    .font(.body)
            }.padding()
            Text("$ 22 222,00")
                .font(.largeTitle)
                .bold()
            HStack {
                Image(systemName: "arrow.up")
                Text("$ 8,58 (0.05 %)")
            }
            .font(.subheadline)
            .foregroundColor(Color.green.opacity(0.5))
            Divider()
        }
    }
}

struct AccountHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AccountHeaderView()
            Spacer()
        }
    }
}
