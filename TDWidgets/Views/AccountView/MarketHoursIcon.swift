//
//  MarketHoursTypeIcon.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 1/6/21.
//

import SwiftUI

struct MarketHoursTypeIcon: View {
    @State var title: String
    @State var color: Color

    var body: some View {
        Text(title)
            .bold()
            .font(.footnote)
            .padding(4)
            .foregroundColor(.white)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .circular))
    }
}

struct MarketHoursIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MarketHoursTypeIcon(title: "pre market", color: Colors.morningOrange)
            MarketHoursTypeIcon(title: "open", color: Colors.oliveGreen)
            MarketHoursTypeIcon(title: "after market", color: Colors.nightPurple)
        }
    }
}
