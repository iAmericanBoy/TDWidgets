//
//  AccountWidgetView.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct AccountWidgetView: View {
    @State var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            AccountWidgetHeaderView(entry: entry)
            if entry.row1.isEmpty == false {
                LazyHGrid(rows: [GridItem(.flexible())], content: {
                    GridStockView(gridValue: entry.row1[0])
                    GridStockView(gridValue: entry.row1[1])
                })
                Divider()
            }
            if entry.row2.isEmpty == false {
                LazyHGrid(rows: [GridItem(.flexible())], content: {
                    GridStockView(gridValue: entry.row2[0])
                    GridStockView(gridValue: entry.row2[1])
                })
                Divider()
            }
        }
        .padding(10)
    }
}

struct AccountWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountWidgetView(entry: AccountEntry.TestingVariation.updated(Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AccountWidgetView(entry: AccountEntry.TestingVariation.complete)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AccountWidgetView(entry: AccountEntry.TestingVariation.openComplete)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            AccountWidgetView(entry: AccountEntry.TestingVariation.closedComplete)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
