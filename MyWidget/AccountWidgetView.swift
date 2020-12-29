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
        HStack {
            Text("\(entry.date, style: .relative) ago")
                .font(.subheadline)
                .bold()
                .foregroundColor(Color.gray.opacity(0.5))
        }
    }
}

struct AccountWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        AccountWidgetView(entry: AccountEntry.TestingVariation.complete)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
