//
//  EmojiCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiCollectionViewCellDelegate: class {
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchDown emoji: String)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpInside emoji: String)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpOutside emoji: String)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, longPress emojis: [String])
}

final class EmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiButton: UIButton!
    weak var delegate: EmojiCollectionViewCellDelegate?
    var emojis: [String]! {
        didSet {
            emojiButton.setTitle(emojis.first, for: .normal, animated: false)
        }
    }
    var emojiFontSize: CGFloat = 29 {
        didSet {
            emojiButton.titleLabel?.font = UIFont.systemFont(ofSize: emojiFontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - User Interactions

extension EmojiCollectionViewCell {
    @IBAction func emojiButtonTouchDown(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchDown: emojis[0])
    }
    
    @IBAction func emojiButtonTouchUpInside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpInside: emojis[0])
    }
    
    @IBAction func emojiButtonTouchUpOutside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpOutside: emojis[0])
    }
    
    @objc private func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        guard emojis.count > 1 else { return }
        delegate?.emojiCollectionViewCell(self, longPress: emojis)
    }

}

// MARK: - Privates

extension EmojiCollectionViewCell {
    private func setupViews() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        emojiButton.addGestureRecognizer(longPressGestureRecognizer)
    }
}

extension Constant {
    struct EmojiCollectionViewCell {
        static let identifier = "EmojiCollectionViewCell"
        static let size = CGSize(width: 37, height: 37)
    }
}
