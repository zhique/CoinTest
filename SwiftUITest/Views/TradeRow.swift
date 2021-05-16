//
//  TradeRow.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/15.
//

import SwiftUI

struct TradeRow: View {
    var trade: Trade
    var body: some View {
        VStack(alignment: .leading) {
            VStack{
                HStack {
                    Text(trade.type.mark.text + String(trade.univalence))
                        .font(.title3)
                        .foregroundColor(trade.type.mark.color)
                    Spacer()
                    Text(String(format: "*%.2f", trade.number))
                        .font(.subheadline)
                    Spacer()
                    Text(String(format: "%@%.2f", trade.type.mark.text, trade.univalence*trade.number))
                        .font(.subheadline)
                        .foregroundColor(trade.type.mark.color)
                }
            }
            Text(trade.tradeDate())
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.top, 1)
        }
        .padding(8)
    }
}

struct TradeRow_Previews: PreviewProvider {
    static var previews: some View {
        if let trade = DataManager.shared.cacheTrades["ETH"]?.first {
            TradeRow(trade: trade)
            .previewLayout(.fixed(width: 300, height: 60))
        } else {
            ContentView()
        }
    }
}

struct AverageRow: View {
    var summaryInfo: ViewModel.AverageSummaryInfo
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Average univalence")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(summaryInfo.type.mark.text + String(summaryInfo.average))
                    .font(.subheadline)
                    .foregroundColor(summaryInfo.type.mark.color)
            }
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Number")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "*%.2f", summaryInfo.numbers))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            VStack(alignment: .leading) {
                Text(summaryInfo.type == .buy ? "Expand" : "Income")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(summaryInfo.type.mark.text + String(summaryInfo.totalValue))
                    .font(.subheadline)
                    .foregroundColor(summaryInfo.type.mark.color)
            }
        }
        .padding(10)
    }
}

struct AverageRow_Previews: PreviewProvider {
    static var previews: some View {
        if let coin = DataManager.shared.coins.first {
            let viewModel = ViewModel(coin)
            AverageRow(summaryInfo: viewModel.averageUnivalence(type: .buy))
            .previewLayout(.fixed(width: 300, height: 60))
        } else {
            ContentView()
        }
    }
}

struct EarningRow: View {
    var earningsInfo: ViewModel.EarningsInfo
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text("Earning")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(earningsInfo.type.mark.text + String(format: "%.2f", earningsInfo.earning))
                    .font(.subheadline)
                    .foregroundColor(earningsInfo.type.mark.color)
            }
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Rate of return")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(earningsInfo.rate)
                    .font(.caption)
                    .foregroundColor(earningsInfo.type.mark.color)
            }
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Left")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "*%.2f", earningsInfo.left))
                    .font(.subheadline)
                    .foregroundColor(earningsInfo.left == 0 ? .red : .black)
            }
        }
        .padding(10)
    }
}

struct EarningRow_Previews: PreviewProvider {
    static var previews: some View {
        if let coin = DataManager.shared.coins.first {
            let viewModel = ViewModel(coin)
            EarningRow(earningsInfo: viewModel.calculateEarnings())
            .previewLayout(.fixed(width: 300, height: 60))
        } else {
            ContentView()
        }
    }
}
