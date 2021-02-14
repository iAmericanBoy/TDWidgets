//
//  GridStockView.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct GridStockView: View {
    @State var gridValue: AccountEntry.GridValue

    var body: some View {
        VStack(alignment: .leading) {
            Text(gridValue.symbol)
                .font(.footnote)
            HStack(spacing: 2) {
                Image(systemName: gridValue.arrowName)
                Text(gridValue.string)
            }
            .font(.footnote)
            .foregroundColor(gridValue.color.opacity(0.9))
        }
    }
}

struct GridStockView_Previews: PreviewProvider {
    static var previews: some View {
        GridStockView(gridValue: AccountEntry.TestingVariation.complete.row1[0])
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
