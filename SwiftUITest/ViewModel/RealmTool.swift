//
//  RealmTool.swift
//  SwiftUITest
//
//  Created by Leo Xiao on 2021/5/15.
//

import Foundation
import RealmSwift
import Realm

public typealias RealmDoneTask = () -> Void

class RealmTools: NSObject {
    class func getDB(userID: String?) -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/\(userID ?? "")Default.realm")
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        print("db address->\(defaultRealm.configuration.fileURL?.absoluteString ?? "")")
        return defaultRealm
    }
    
    /*
    /// 单粒
    static let sharedInstance = RealmTools()
    /// 当前的 Realm
    fileprivate var currentRealm: Realm? {
        return try! Realm()
    }
    /// 当前realm存储的路径
    static var fileURL: URL? {
        return sharedInstance.currentRealm?.configuration.fileURL
    }
    /// 当前的版本号
    fileprivate var currentSchemaVersion: UInt64 = 0
    /// 当前的加密字符串
    fileprivate var currentKeyWord: String? = "" */
}

// MARK:- Realm数据库配置和版本差异化配置
/**
 通过调用 Realm() 来初始化以及访问我们的 realm 变量。其指向的是应用的 Documents 文件夹下的一个名为“default.realm”的文件。
 通过对默认配置进行更改，我们可以使用不同的数据库。比如给每个用户帐号创建一个特有的 Realm 文件，通过切换配置，就可以直接使用默认的 Realm 数据库来直接访问各自数据库
 */
// 在(application:didFinishLaunchingWithOptions:)中进行配置

/// 配置
extension RealmTools {
    ///  配置数据库
    public class func configRealm(userID: String?,
                                  keyWord: String? = nil,
                                  schemaVersion: UInt64 = 0, migrationBlock: MigrationBlock? = nil) {
        /// 这个方法主要用于数据模型属性增加或删除时的数据迁移，每次模型属性变化时，将 dbVersion 加 1 即可，Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构，移除属性的数据将会被删除。
        let dbVersion : UInt64 = schemaVersion
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/\(userID ?? "")Default.realm")
        
        /*let config = Realm.Configuration(fileURL: URL(string: dbPath), schemaVersion: schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
            if oldSchemaVersion < 1 {
                // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
            }
            // 低版本的数据库迁移......
            if migrationBlock != nil {
                migrationBlock!(migration, oldSchemaVersion)
            }
        })
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
         
        guard let realm = try? Realm(configuration: config) else {
            return
        }
        sharedInstance.currentSchemaVersion = schemaVersion
        sharedInstance.currentRealm = realm
        sharedInstance.currentKeyWord = keyWord*/
        
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            // oldSchemaVersion == 0
            if oldSchemaVersion < 1 {
                // do nothing！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
            }
            if migrationBlock != nil {
                migrationBlock!(migration, oldSchemaVersion)
            }
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm) in
            print("Realm configure successful!")
        }
//        guard let realm = try? Realm(configuration: config) else {
//            return
//        }
//        sharedInstance.currentSchemaVersion = schemaVersion
//        sharedInstance.currentRealm = realm
//        sharedInstance.currentKeyWord = keyWord*/
    }
    
    
    // MARK: 删除当前的realm库
    /// 删除当前的realm库
    @discardableResult
    public class func deleteRealmFiles(userID: String?,
                                  keyWord: String? = nil, currentSchemaVersion: UInt64 = 0) -> Bool {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/ + \(userID ?? "")Default.realm")
        
        guard let realmURL = URL(string: dbPath) else { return false }

        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
                self.configRealm(userID: nil, keyWord: keyWord, schemaVersion: currentSchemaVersion)
            } catch {
                // handle error
               return false
            }
        }
        return true
    }
}


/*
extension RealmTools {

    // MARK: 配置数据库，为用户提供个性化的 Realm 配置(加密暂时没有使用)
    /// 配置数据库，为用户提供个性化的 Realm 配置
    /// - Parameters:
    ///   - userID: 用户的ID
    ///   - keyWord: 加密字符串
    ///   - schemaVersion: 设置新的架构版本(如果要存储的数据模型属性发生变化)，这个版本号必须高于之前所用的版本号，如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    static func configRealm(userID: String?,
                        keyWord: String? = nil,
                        schemaVersion: UInt64 = 0, migrationBlock: MigrationBlock? = nil) {
        // 加密串128位结果为：464e5774625e64306771702463336e316a4074487442325145766477335e21346b715169364c406c6a4976346d695958396245346e356f6a62256d2637566126
        // let key: Data = "FNWtb^d0gqp$c3n1j@tHtB2QEvdw3^!4kqQi6L@ljIv4miYX9bE4n5ojb%m&7Va&".data(using: .utf8, allowLossyConversion: false)!
        // 加密的key
        // let key: Data = keyWord.data(using: .utf8, allowLossyConversion: false)!
        // 打开加密文件
        // (encryptionKey: key)
        // 使用默认的目录，但是使用用户 ID 来替换默认的文件名
        let fileURL = FileManager.DocumnetsDirectory() + "/" + ("\(userID ?? "")default.realm")
        let config = Realm.Configuration(fileURL: URL(string: fileURL), schemaVersion: schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
            if oldSchemaVersion < 1 {
                // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
            }
            // 低版本的数据库迁移......
            if migrationBlock != nil {
                migrationBlock!(migration, oldSchemaVersion)
            }
        })
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        guard let realm = try? Realm(configuration: config) else {
            return
        }
        sharedInstance.currentSchemaVersion = schemaVersion
        sharedInstance.currentRealm = realm
        sharedInstance.currentKeyWord = keyWord
    }

    // MARK: 删除当前的realm库
    /// 删除当前的realm库
    @discardableResult
    static func deleteRealmFiles() -> Bool {
        let realmURL = sharedInstance.currentRealm?.configuration.fileURL ?? Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
                self.configRealm(userID: nil, keyWord: sharedInstance.currentKeyWord, schemaVersion: sharedInstance.currentSchemaVersion)
            } catch {
                // handle error
               return false
            }
        }
        return true
    }
}*/

