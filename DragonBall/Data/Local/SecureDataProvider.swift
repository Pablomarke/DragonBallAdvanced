//
//  SecureDataProvider.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 14/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func get() -> String?
    func delete()
}

final class SecureDataProvider: SecureDataProviderProtocol {

    private let keychain = KeychainSwift()
    
    private enum key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: key.token)
    }
    
    func get() -> String? {
        keychain.get(key.token)
    }
    
    func delete() {
        keychain.clear()
    }
    
  
}
