//
//  MarketHoursIcon.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/6/21.
//

import SwiftUI

struct MarketHoursIcon: View {
    @State var title: String

    var body: some View {
        Text(title)
            .font(.footnote)
            .padding(4)
            .foregroundColor(.black)
            .background(Color.green.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
            .overlay(RoundedRectangle(cornerRadius: 25, style: .circular)
                .stroke(Color.black, lineWidth: 2))
    }
}

struct MarketHoursIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarketHoursIcon(title: "pre market")
            MarketHoursIcon(title: "open")
            MarketHoursIcon(title: "after Market")
        }
    }
}
