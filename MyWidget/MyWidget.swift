//
//  MyWidget.swift
//  MyWidget
//
//  Created by Dominic Lanzillotta on 12/29/20.
//

import os
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    let viewModel = AccountWidgetEntryFactory()

    func placeholder(in context: Context) -> AccountEntry {
        AccountEntry.SnapshotVariation.complete
    }

    func getSnapshot(in context: Context, completion: @escaping (AccountEntry) -> ()) {
        let entry = AccountEntry.SnapshotVariation.complete
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AccountEntry>) -> ()) {
        let logger = Logger()
        logger.debug("get accounts is called")
        viewModel.createTimeline { timeline in
            logger.debug("Timeline created")
            completion(timeline)
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AccountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MyWidget")
        .description("This is a simple widget to see an overview of a TD Trading Account")
        .onBackgroundURLSessionEvents { _, _ in
        }
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        AccountWidgetView(entry: AccountEntry.TestingVariation.complete)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
