//
//  AccountView.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 12/22/20.
//

import Combine
import SwiftUI

struct AccountHeaderView: View {
    @ObservedObject var viewModel: AccountViewModel

    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title)
                    .font(.headline)
                Spacer()
                Image(systemName: "star")
                    .font(.body)
            }.padding()
            Text(viewModel.balance)
                .font(.largeTitle)
                .bold()
            HStack {
                Image(systemName: viewModel.arrowImageName)
                Text(viewModel.balanceSubTitle)
            }
            .font(.subheadline)
            .foregroundColor(Color.green.opacity(0.5))
            Divider()
        }
    }
}

struct AccountHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AccountHeaderView(viewModel: AccountViewModel(repository: MockRepositry.PreviewVariation.complete))
            Spacer()
        }
    }
}
