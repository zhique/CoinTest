//
//  Coin.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/4/7.
//

import Foundation
import SwiftUI
import RealmSwift

@objc(RealmSwiftCoin)
class Coin: Object, Identifiable {
    @objc static let identifier = "id"
    static let totalBoughtValue = "totalBoughtValue"
    @objc dynamic var id: String = ""
    @objc dynamic var buyAverage: Double = 0.0
    @objc dynamic var number: Double = 0.0
    @objc dynamic var totalBoughtValue: Double = 0.0 // TODO: delete
    @objc dynamic var marketValue: Double = 0.0
    @objc dynamic var comments: String = ""
    @objc dynamic var tags: String = ""
    @objc dynamic var bought: Bool = true
    @objc dynamic var earning: Double = 0.0
    @objc dynamic var earningRate: String = ""

    @objc override public class func primaryKey() -> String? {
        return Coin.identifier
    }
    
    convenience init(_ id: String?, totalBoughtValue: Double? = 0, tags: String = "", comments: String = "") {
        self.init()
        if let id = id { self.id = id }
        self.tags = tags
        self.totalBoughtValue = totalBoughtValue ?? 0
        self.comments = comments
    }
    
    /// add coin
    func add() {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            realm.add(self)
        }
    }
    
    /// update coin, failed method
    func updateValues() {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            realm.add(self, update: .modified)
            
        }
    }
    
    /// update coin comments
    @objc func updateCoinComment(tags: String? = nil, comment: String? = nil) {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            if let tags = tags { self.tags = tags }
            if let comment = comment { self.comments = comment }
            realm.add(self, update: .modified)
        }
    }

    /// delete coin
    func delete(clearTrades: Bool = true) {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            /// delete all trades first
            if clearTrades {
                let predicate = NSPredicate(format: "coinId == %@", self.id)
                let results: Results<Trade> = realm.objects(Trade.self).filter(predicate)
                if results.count > 0 {
                    realm.delete(results)
                }
            }
            realm.delete(self)
        }
    }
    
    /// delete trades
    func deleteTrades(standardTrade: Trade, beforeThisTrade: Bool = false) {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            if beforeThisTrade {
                let predicate = NSPredicate(format: "coinId == %@ AND timestamp <= %@", self.id, standardTrade.timestamp)
                let results: Results<Trade> = realm.objects(Trade.self).filter(predicate)
                if results.count > 0 {
                    realm.delete(results)
                }
            }
        }
    }
    
}

@objc(RealmSwiftTrade)
class Trade: Object, Identifiable {
    @objc static let identifier = "id"
    static let timestamp = "timestamp"
    enum TradeType: String, CaseIterable, Identifiable {
        case buy
        case sell
        case average
        case happy
        case unHappy
        
        var id: String { self.rawValue }
        
        var mark: (text: String, color: Color) {
            switch self {
            case .buy, .unHappy:
                return ("-", .red)
            case .sell, .happy:
                return ("+", .green)
            case .average:
                return ("ave ", .purple)
            }
        }
        
        static var allCases: [TradeType] {
            return [.buy, .sell]
        }
    }
    // TODO: primart key automic add, then the update method will effect
    @objc var id: Int = 0
    var coinId: String = ""
    var univalence: Double = 0.0
    var type: TradeType = .buy
    var number: Double = 0.0
    var timestamp: TimeInterval = 0
    var date: Date = Date() {
        didSet {
            // TODO: check it
            self.timestamp = date.timeIntervalSince1970
        }
    }
    var totalValue: Double = 0.0
    var remedyAfterUnivalence: Double = -1
    
    @objc override public class func primaryKey() -> String? {
        return Trade.identifier
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Trade.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    convenience init(coinId: String, univalence: Double? = nil, number: Double? = nil, type: TradeType = .buy, date: Date = Date()) {
        self.init()
        self.coinId = coinId
        if let univalence = univalence { self.univalence = univalence }
        if let number = number { self.number = number }
        self.type = type
        self.date = date
        self.totalValue = calculateTotalValue()
    }
    
    func calculateTotalValue() -> Double {
        self.totalValue = self.univalence * self.number
        return self.totalValue
    }
    
    /// add trade
    func add() {
        let realm = RealmTools.getDB(userID: "PXiao")
        self.id = incrementID()
        try! realm.write {
            realm.add(self)
        }
    }
    
    /// update trade
    /// add the parameters to update?
    func updateTrade() {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            realm.add(self, update: .modified)
        }
    }


    /// delete trade
    func delete() {
        let realm = RealmTools.getDB(userID: "PXiao")
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func tradeDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateS = formatter.string(from: date)
        return dateS
    }
}


// TODO: add stage object and operation
