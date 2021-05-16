//
//  CoinRow.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/13.
//

import SwiftUI

struct CoinRow: View {
    @State var isShowEditCoin = false
    var coin: Coin
    var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    if coin.tags.split(separator: " ").count > 0 {
                        ForEach(0 ..< coin.tags.split(separator: " ").count) { index in
                            Text(coin.tags.split(separator: " ")[index])
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .padding(.bottom, 1)
                                .background(Color.blue.opacity(0.3))
                        }
                    }
                }
                VStack{
                    HStack {
                        Text(coin.id)
                            .font(.headline)
                        CoinsEditButton(isShowEditCoin: self.$isShowEditCoin, coin: coin)
                            .frame(width: 30, height: 30, alignment: .leading)
                        Spacer()
                        Text("price:--.--")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        Spacer()
                        Text(String("--.--"))
                            .font(.subheadline)
                            .foregroundColor(Color.green)
                    }
                    HStack {
                        Text("\(coin.number)") // numbers
                            .font(.footnote)
                        Spacer()
                        Text("-\(coin.buyAverage)") // unit price
                            .font(.footnote)
                            .foregroundColor(.red)
                        
                        Spacer()
                        Text(String("-\(coin.totalBoughtValue)"))
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
                Text(coin.comments)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(10)
            
//            Spacer()
//            Button(action: {
//                isShowEditCoin = true
//            }, label: {
//                Label("", systemImage: "square.and.pencil")
//            })
//            NavigationLink(
//                destination: EditCoinView.init(coin: coin, showing: self.$isShowEditCoin), isActive: self.$isShowEditCoin) {
//            }
    }
}

struct CoinRow_Previews: PreviewProvider {
    static var previews: some View {
        CoinRow(coin: DataManager.shared.coins[0])
        .previewLayout(.fixed(width: 300, height: 80))
    }
}

