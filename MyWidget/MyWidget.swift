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
    let viewModel = AccountWidgetViewModel()

    func placeholder(in context: Context) -> AccountEntry {
        AccountEntry.TestingVariation.complete
    }

    func getSnapshot(in context: Context, completion: @escaping (AccountEntry) -> ()) {
        let entry = AccountEntry.TestingVariation.complete
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AccountEntry>) -> ()) {
        let logger = Logger()
        logger.debug("get accounts is called")
        viewModel.getAccounts { response in
            logger.debug("get Accounts result received")
            switch response {
            case .success(let entry):
                logger.debug("received entry")
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            case .failure(let error):
                logger.debug("received error")
                print(error)
                let timeline = Timeline(entries: [AccountEntry.TestingVariation.updated(Date())], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AccountWidgetView(entry: entry)
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
