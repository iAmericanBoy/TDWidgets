//
//  AccountWidgetView.swift
//  MyWidgetExtension
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct AccountWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if entry.isError {
            Text("Error")
        } else {
            AccountWidgetView(entry: entry)
        }
    }
}
