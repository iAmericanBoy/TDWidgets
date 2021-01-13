//
//  MarketHoursTypeIcon.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/6/21.
//

import SwiftUI

struct MarketHoursTypeIcon: View {
    @State var viewModel: MarketHourTypeViewModel

    var body: some View {
        Text(viewModel.title)
            .bold()
            .font(.footnote)
            .padding(4)
            .foregroundColor(.white)
            .background(viewModel.color)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
    }
}

struct MarketHoursIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarketHoursTypeIcon(viewModel: .pre)
            MarketHoursTypeIcon(viewModel: .regular)
            MarketHoursTypeIcon(viewModel: .post)
            MarketHoursTypeIcon(viewModel: .closed)
        }
    }
}
