//
//  SimpleStockView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import SwiftUI

struct SimpleStockView: View {
    var body: some View {
        VStack(spacing: -3) {
            HStack {
                Text("Apple")
                    .bold()
                Spacer()
                Text("$ 1 034,56")
                    .bold()
            }
            HStack {
                HStack {
                    Text("AAPL")
                    Text("ᐧ")
                        .bold()
                        .font(.title)
                    Text("5 Shares")
                }.foregroundColor(Color.black.opacity(0.5))
                    .font(.body)
                Spacer()
                HStack {
                    Image(systemName: "arrow.up")
                    Text("$ 8,58 (0.05 %)")
                }
                .font(.subheadline)
                .foregroundColor(Color.green.opacity(0.5))
            }
        }.padding(6)
    }
}

struct SimpleStockView_Previews: PreviewProvider {
    static var previews: some View {
        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
            SimpleStockView()
        }
    }
}
