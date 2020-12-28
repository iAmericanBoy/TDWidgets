//
//  SimpleStockRow.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import SwiftUI

struct SimpleStockRow: View {
    var viewModel: SimpleStockRowViewModel

    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text(viewModel.symbol)
                    .bold()
                Spacer()
                Text(viewModel.marketValueString)
                    .bold()
            }
            HStack {
                HStack {
                    Text(viewModel.quanityString)
                }.foregroundColor(Color.black.opacity(0.5))
                    .font(.body)
                Spacer()
                HStack {
                    Image(systemName: viewModel.profitLossSymbol)
                    Text(viewModel.profitLossString)
                }
                .font(.subheadline)
                .foregroundColor(viewModel.profitLossColor.opacity(0.5))
            }
        }.padding(6)
    }
}

struct SimpleStockView_Previews: PreviewProvider {
    static var previews: some View {
        List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { _ in
            SimpleStockRow(viewModel: SimpleStockRowViewModel.TestingVariation.completeApple)
        }
    }
}
