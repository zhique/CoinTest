//
//  TradeList.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/15.
//

import SwiftUI

struct TradeList: View {
    @State var isShowEditCoin = false
    @State var isShowAddTrade = false

    var viewModel: ViewModel
    var body: some View {
        if let coin = viewModel.currentCoin {
            NavigationView {
                VStack {
                    Button(action: {
                        isShowEditCoin = true
                    }, label: {
                        NavigationLink(destination: EditCoinView.init(coin: coin, showing: self.$isShowEditCoin), isActive: self.$isShowEditCoin) {
                        }
                    })

                    Button(action: {
                        isShowAddTrade = true
                    }, label: {
                        NavigationLink(destination: AddTradeView(trade: Trade(coinId: coin.id), showing: $isShowAddTrade), isActive: $isShowAddTrade) {
                        }
                    })
                    
                    if let trades = DataManager.shared.cacheTrades["ETH"] {
                        List() {
                            Section(header: Text("Summary Info")) {
                                let viewModel = ViewModel(coin)
                                AverageRow.init(summaryInfo: viewModel.averageUnivalence(type: .buy))
                                AverageRow.init(summaryInfo: viewModel.averageUnivalence(type: .sell))
                                EarningRow.init(earningsInfo: viewModel.calculateEarnings())
                            }
                            Section(header: TradesHeader(coin: coin, isShowAddTrade: self.$isShowAddTrade)) {
                                ForEach(0 ..< trades.count) { index in
                                    TradeRow(trade: trades[index])
                                }
                            }.deleteDisabled(true)
                        }
                    } else {
                        TradesHeader(coin: coin, isShowAddTrade: self.$isShowAddTrade)
                    }
                }
                .navigationTitle(coin.id)
                .navigationBarItems(trailing: {
                    CoinsEditButton(isShowEditCoin: self.$isShowEditCoin, coin: coin)
                }())
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        else {
            Text("No coin, no trades")
        }
    }
}

struct TradeList_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel.init(DataManager.shared.coins.first)
        TradeList(viewModel: viewModel)
    }
}

struct TradesHeader: View {
    var coin: Coin
    @Binding var isShowAddTrade: Bool
    var body: some View {
        HStack {
            Text("Trades")
                .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Spacer()
            Button(action: {
                // buttonAction()
                self.isShowAddTrade = true
            }, label: {
                Label("", systemImage: "arrow.up.arrow.down")
            })
            NavigationLink(
                destination: AddTradeView(trade: Trade(coinId: coin.id), showing: self.$isShowAddTrade), isActive: self.$isShowAddTrade) {
                Image(systemName: "plus")
            }
            .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        }
    }
}

//struct TradesHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        let coin = Coin.init("ETH")
//        TradesHeader(coin: coin, isShow: true)
//        .previewLayout(.fixed(width: 300, height: 60))
//    }
//}

struct CoinsEditButton: View {
    @Binding var isShowEditCoin: Bool
    var coin: Coin
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                isShowEditCoin = true
            }, label: {
                Label("", systemImage: "square.and.pencil")
            })
            NavigationLink(
                destination: EditCoinView.init(coin: coin, showing: self.$isShowEditCoin), isActive: self.$isShowEditCoin) {
//                Image(systemName: "square.and.pencil")
//                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                    .padding(1)
            }
        }
    }
}
