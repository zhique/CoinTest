//
//  ViewModel.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/9.
//

import Foundation

class ViewModel {
    typealias AverageSummaryInfo = (type:Trade.TradeType, average: Double, numbers: Double, totalValue: Double)
    typealias EarningsInfo = (type:Trade.TradeType, earning: Double, rate: String, left: Double)
    
    init(_ coin: Coin?) {
        self.currentCoin = coin
    }
    
    var coins: [Coin] {
        return DataManager.shared.coins
    }
    
    var currentCoin: Coin?
    
    var trades: [Trade] {
        guard let currentCoin = currentCoin else {
            return [Trade]()
        }
        guard let cachedTrades = DataManager.shared.cacheTrades[currentCoin.id] else {
            return DataManager.shared.loadTrades(coinId: currentCoin.id)
        }
        return cachedTrades
    }
    
    /// TODO: add calculate method in viewModel
    func averageUnivalence(type: Trade.TradeType) -> AverageSummaryInfo {
        var info = (type: type, average: 0.0, numbers: 0.0, totalValue: 0.0)
        guard let coin = currentCoin, let trades = DataManager.shared.cacheTrades[coin.id] else {
            return info
        }
        for trade in trades.filter({$0.type == type}) {
            info.numbers += trade.number
            info.totalValue += trade.totalValue
        }
        info.average = info.totalValue/info.numbers
        
        if type == .buy {
            coin.buyAverage = info.average
            coin.totalBoughtValue = info.totalValue
            coin.updateValues()
        }
        
        return info
    }
    
    func calculateEarnings() -> EarningsInfo {
        guard let coin = currentCoin else { return (.happy, earning: 0.0, rate: "0.00%", 9999.0) }
        let boughtInfo = averageUnivalence(type: .buy)
        let saleInfo = averageUnivalence(type: .sell)
        
        let totalCost = boughtInfo.average * saleInfo.numbers
        let earning = saleInfo.average * saleInfo.numbers - totalCost
        let rate = earning/totalCost
        let type:Trade.TradeType = earning > 0 ? .happy : .unHappy
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        let rateString = type.mark.text + (formatter.string(from: NSNumber(value: rate)) ?? "-.--%")
        
        if (fabs(saleInfo.numbers - boughtInfo.numbers) < 1.0) {
            // TODO: write to stage table
            coin.number = 0
            coin.earning = earning
            coin.earningRate = rateString
            coin.updateValues()
            return (type, earning, rateString, 0)
        } else {
            /// coin number is the left numbers
            coin.number = boughtInfo.numbers - saleInfo.numbers
            coin.earning = earning
            coin.earningRate = rateString
            coin.updateValues()
            return (type, earning, rateString, boughtInfo.numbers - saleInfo.numbers)
        }
    }
    
}
