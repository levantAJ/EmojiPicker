//
//  EmojiPickerViewModel.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Foundation

protocol EmojiPickerViewModelProtocol {
    var numberOfSections: Int { get }
    func numberOfEmojis(section: Int) -> Int
    func emoji(at indexPath: IndexPath) -> Emoji?
    func select(emoji: Emoji)
}

final class EmojiPickerViewModel {
    var emojis: [Int: [Emoji]] = [:]
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
        if let data = userDefaults.data(forKey: Constant.EmojiPickerViewModel.frequentlyUsed) {
            let frequentlyUsedEmojis = try! JSONDecoder().decode([Emoji].self, from: data)
            self.emojis[EmojiGroup.frequentlyUsed.index] = frequentlyUsedEmojis
        }
        let systemVersion = UIDevice.current.systemVersion
        let path: String
        if systemVersion.compare("10", options: .numeric) == .orderedAscending {
            path = Bundle(for: EmojiPickerViewModel.self).path(forResource: "emojis9.1", ofType: "json")!
        } else if systemVersion.compare("12", options: .numeric) == .orderedAscending {
            path = Bundle(for: EmojiPickerViewModel.self).path(forResource: "emojis11.0.1", ofType: "json")!
        } else {
            path = Bundle(for: EmojiPickerViewModel.self).path(forResource: "emojis", ofType: "json")!
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let emojis = try! JSONDecoder().decode([Category].self, from: data)
        for emoji in emojis {
            self.emojis[emoji.type.index] = emoji.emojis
        }
    }
}

// MARK: - EmojiPickerViewModelProtocol

extension EmojiPickerViewModel: EmojiPickerViewModelProtocol {
    var numberOfSections: Int {
        return emojis.count
    }
    
    func numberOfEmojis(section: Int) -> Int {
        guard let type = EmojiGroup(index: section) else { return 0 }
        return emojis[type.index]?.count ?? 0
    }
    
    func emoji(at indexPath: IndexPath) -> Emoji? {
        guard let type = EmojiGroup(index: indexPath.section) else { return nil }
        return emojis[type.index]?[indexPath.item]
    }
    
    func select(emoji: Emoji) {
        var frequentlyUsedEmojis: [Emoji] = []
        if let data = userDefaults.data(forKey: Constant.EmojiPickerViewModel.frequentlyUsed) {
            frequentlyUsedEmojis = try! JSONDecoder().decode([Emoji].self, from: data)
        }
        if let index = frequentlyUsedEmojis.firstIndex(where: { $0.emojis == emoji.emojis }) {
            frequentlyUsedEmojis.remove(at: index)
        }
        frequentlyUsedEmojis = [emoji] + frequentlyUsedEmojis
        frequentlyUsedEmojis = Array(frequentlyUsedEmojis.prefix(upTo: min(frequentlyUsedEmojis.count, 30)))
        emojis[EmojiGroup.frequentlyUsed.index] = frequentlyUsedEmojis
        let data = try! JSONEncoder().encode(frequentlyUsedEmojis)
        userDefaults.set(data, forKey: Constant.EmojiPickerViewModel.frequentlyUsed)
    }
}

struct Constant {
    struct EmojiPickerViewModel {
        static let frequentlyUsed = "com.levantAJ.EmojiPicker.frequentlyUsed"
    }
}
