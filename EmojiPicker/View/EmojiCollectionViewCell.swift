//
//  EmojiCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiCollectionViewCellDelegate: class {
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchDown emojis: [String])
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpInside emojis: [String])
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpOutside emojis: [String])
}

final class EmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiLabel: UILabel!
    weak var delegate: EmojiCollectionViewCellDelegate?
    var emojis: [String]! {
        didSet {
            emojiLabel.text = emojis.first
        }
    }
    var emojiFontSize: CGFloat = 31 {
        didSet {
            emojiLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
        }
    }
}

// MARK: - User Interactions

extension EmojiCollectionViewCell {
    @IBAction func emojiButtonTouchDown(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchDown: emojis)
    }
    
    @IBAction func emojiButtonTouchUpInside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpInside: emojis)
    }
    
    @IBAction func emojiButtonTouchUpOutside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpOutside: emojis)
    }
}

extension Constant {
    struct EmojiCollectionViewCell {
        static let identifier = "EmojiCollectionViewCell"
        static let size = CGSize(width: 37, height: 37)
    }
}
