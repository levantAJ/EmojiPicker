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
    func emojis(at indexPath: IndexPath) -> [String]?
}

final class EmojiPickerViewModel {
    var emojis: [Int: [[String]]] = [:]
    
    init() {
        let frequentlyUsedEmojis = UserDefaults.standard.array(forKey: Constant.EmojiPickerViewModel.frequentlyUsed) as? [[String]]
        self.emojis[EmojiGroup.frequentlyUsed.index] = frequentlyUsedEmojis ?? []
        let path = Bundle(for: EmojiPickerViewModel.self).path(forResource: "emojis", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let emojis = try! JSONDecoder().decode([Emoji].self, from: data)
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
    
    func emojis(at indexPath: IndexPath) -> [String]? {
        guard let type = EmojiGroup(index: indexPath.section) else { return nil }
        return emojis[type.index]?[indexPath.item]
    }
}

struct Constant {
    struct EmojiPickerViewModel {
        static let frequentlyUsed = "com.levantAJ.EmojiPicker.frequentlyUsed"
    }
}
