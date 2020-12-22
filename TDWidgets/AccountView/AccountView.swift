//
//  AccountView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack {
            AccountHeaderView(viewModel: AccountViewModel())
            Spacer()
            List(0 ..< 8) { _ in
                SimpleStockView()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
