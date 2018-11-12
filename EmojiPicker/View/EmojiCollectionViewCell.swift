//
//  EmojiCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiLabel: UILabel!
    var emojis: [String]! {
        didSet {
            emojiLabel.text = emojis.first
        }
    }
    var fontSize: CGFloat = 31 {
        didSet {
            emojiLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

extension Constant {
    struct EmojiCollectionViewCell {
        static let identifier = "EmojiCollectionViewCell"
    }
}
