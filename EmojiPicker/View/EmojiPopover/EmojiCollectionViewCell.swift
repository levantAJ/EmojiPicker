//
//  EmojiCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiCollectionViewCellDelegate: class {
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchDown emoji: Emoji)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpInside emoji: Emoji)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, touchUpOutside emoji: Emoji)
    func emojiCollectionViewCell(_ cell: EmojiCollectionViewCell, longPress emoji: Emoji)
}

final class EmojiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var emojiButton: UIButton!
    weak var delegate: EmojiCollectionViewCellDelegate?
    lazy var vibrator: Vibratable = Vibrator()
    var emoji: Emoji! {
        didSet {
            let title = emoji.selectedEmoji ?? emoji.emojis.first
            emojiButton.setTitle(title, for: .normal, animated: false)
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
        delegate?.emojiCollectionViewCell(self, touchDown: emoji)
    }
    
    @IBAction func emojiButtonTouchUpInside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpInside: emoji)
    }
    
    @IBAction func emojiButtonTouchUpOutside(_ button: UIButton) {
        delegate?.emojiCollectionViewCell(self, touchUpOutside: emoji)
    }
    
    @objc private func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if emoji.emojis.count == 1 {
            if longPressGestureRecognizer.state == .ended {
                delegate?.emojiCollectionViewCell(self, touchUpInside: emoji)
            }
        } else {
            if longPressGestureRecognizer.state == .began {
                vibrator.vibrate()
                delegate?.emojiCollectionViewCell(self, longPress: emoji)
            }
        }
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
