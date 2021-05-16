//
//  DataManager.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/9.
//

import Foundation
import RealmSwift

class DataManager {
    typealias CoinKey = String
    
    static let shared = DataManager.init()
    
    var coins: [Coin] {
       return loadCoins()
    }
//    {
//        // Mock data temporary
//        var mockCoins = [Coin]()
//        let coin1 = Coin.init("ETH", totalBoughtValue: 3600, tags: "Goal-July E-30%", comments: "Big suprise will came until July")
//        let coin2 = Coin.init("SUSHI", totalBoughtValue: 1800, tags: "Goal-SixMonth E-300%", comments: "Big suprise will came until July")
//        mockCoins.append(coin1)
//        mockCoins.append(coin2)
//        return mockCoins
//    }
    var cacheTrades: [CoinKey: [Trade]] = [String: [Trade]]()
//    { // = [String: [Trade]]()
//        // Mock data temporary
//        let trade1 = Trade.init(coinId: "ETH", univalence: 1920, number: 2, type: .buy, date: Date())
//        let trade2 = Trade.init(coinId: "ETH", univalence: 2400, number: 1, type: .sell, date: Date())
//
//        return ["ETH": [trade1, trade2]]
//    }
    
    init() {
        RealmTools.configRealm(userID: "PXiao")
    }
    
    func findTrades(with coinId: CoinKey) -> [Trade]? {
        return nil
    }
    
    /// load data
    /// version2 -support sort by market value
    func loadCoins() -> [Coin] {
        var coins = [Coin]()
        let realm = RealmTools.getDB(userID: "PXiao")
        let items = realm.objects(Coin.self).sorted(byKeyPath: Coin.totalBoughtValue, ascending: false)
        for coin in items {
            coins.append(coin)
        }
        return coins
    }
    
    @discardableResult
    func loadTrades(coinId: CoinKey) -> [Trade] {
        let realm = RealmTools.getDB(userID: "PXiao")
        let predicate = NSPredicate(format: "coinId == %@", coinId)
        let items = realm.objects(Trade.self).filter(predicate).sorted(byKeyPath: Trade.timestamp, ascending: false)
        var trades = [Trade]()
        for trade in items {
            trades.append(trade)
        }
        cacheTrades[coinId] = trades
        return trades
    }
    
    /// TODO: add calculate method in viewModel/manager?
}
