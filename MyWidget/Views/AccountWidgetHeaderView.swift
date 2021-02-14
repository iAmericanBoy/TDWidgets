//
//  AccountWidgetHeaderView.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 2/14/21.
//

import SwiftUI
import WidgetKit

struct AccountWidgetHeaderView: View {
    @State var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Image(systemName: entry.dayProfitLossImage)
                    .frame(width: 25, height: 10, alignment: .center)
                Text(entry.dayProfitLossText)
            }
            .font(.title)
            .foregroundColor(entry.dayProfitLossColor.opacity(0.9))
            if entry.isSessionTypeClosed {
                Text("\(entry.dateText)")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.gray.opacity(0.5))
                Divider()
            } else {
                Text("\(entry.date, style: .relative) \(entry.dateText)")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color.gray.opacity(0.5))
                Divider()
                    .frame(height: 3)
                    .background(entry.sessionTypeColor)
            }
        }
    }
}

struct AccountWidgetHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AccountWidgetHeaderView(entry: AccountEntry.TestingVariation.complete)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
