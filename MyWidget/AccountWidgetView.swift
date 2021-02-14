//
//  AccountWidgetView.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct AccountWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Image(systemName: entry.dayProfitLossImage)
                    .frame(width: 25, height: 10, alignment: .center)
                Text(entry.dayProfitLossPercentage)
            }
            .font(.title)
            .foregroundColor(entry.dayProfitLossColor.opacity(0.9))
            if entry.isSessionTypeClosed {
                Text("\(entry.dateText)")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.gray.opacity(0.5))
            } else {
                Text("\(entry.date, style: .relative) \(entry.dateText)")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            if entry.isSessionTypeClosed {
                Divider()
                    .padding(.vertical, 4)
            } else {
                Divider()
                    .frame(height: 3)
                    .background(entry.sessionTypeColor)
                    .padding(.vertical, 4)
            }

            if entry.row1.isEmpty == false {
                LazyHGrid(rows: [GridItem(.flexible())], content: {
                    GridStockView(gridValue: entry.row1[0])
                    GridStockView(gridValue: entry.row1[1])
                })
                Divider()
                    .padding(.vertical, 4)
            }
            if entry.row2.isEmpty == false {
                LazyHGrid(rows: [GridItem(.flexible())], content: {
                    GridStockView(gridValue: entry.row2[0])
                    GridStockView(gridValue: entry.row2[1])
                })
                Divider()
                    .padding(.vertical, 4)
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
