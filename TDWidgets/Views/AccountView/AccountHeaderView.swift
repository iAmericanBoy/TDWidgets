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
                MarketHoursTypeIcon(viewModel: MarketHourIconViewModel(viewModel.marketSessionType))
                    .padding(10)
                Button(action: {
                    viewModel.streamData()
                }, label: {
                    Image(systemName: viewModel.streamDataImageString)
                        .font(.title)
                        .foregroundColor(Color.black)
                })

            }.padding()
            Text(viewModel.balance)
                .font(.largeTitle)
                .bold()
            HStack {
                Image(systemName: viewModel.arrowImageName)
                Text(viewModel.balanceSubTitle)
            }
            .font(.subheadline)
            .foregroundColor(viewModel.subtitleColor.opacity(0.9))
            HStack {
                Spacer()
                Text(viewModel.timeIntervalString)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(5)
            }

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
