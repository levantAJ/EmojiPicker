//
//  UserDefaultsProtocol.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
}

// MARK: - UserDefaultsProtocol

extension UserDefaults: UserDefaultsProtocol {}
