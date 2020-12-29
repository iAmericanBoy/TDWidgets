//
//  MyWidget.swift
//  MyWidget
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> AccountEntry {
        AccountEntry.TestingVariation.complete
    }

    func getSnapshot(in context: Context, completion: @escaping (AccountEntry) -> ()) {
        let entry = AccountEntry.TestingVariation.complete
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AccountEntry>) -> ()) {
        var entries: [AccountEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = AccountEntry.TestingVariation.complete
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AccountWidgetView(entry: entry)
        }
        .configurationDisplayName("TDWidget")
        .description("This is a simple widget to see an overview of a ID Trading Account")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        AccountWidgetView(entry: AccountEntry.TestingVariation.complete)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
