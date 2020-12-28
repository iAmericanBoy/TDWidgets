//
//  AccountView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        VStack {
            AccountHeaderView(viewModel: viewModel)
            Spacer()
            List(viewModel.simpleStockRowViewModel) { rowViewModel in
                SimpleStockRow(viewModel: rowViewModel)
            }
            Button(action: { () }) {
                EmptyView()
            }.sheet(isPresented: $viewModel.shouldShowSignIn) {
                OAuthView {
                    viewModel.shouldShowSignIn = false
                    viewModel.getAccounts()
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(viewModel: AccountViewModel(repository: MockRepositry.PreviewVariation.complete))
    }
}
