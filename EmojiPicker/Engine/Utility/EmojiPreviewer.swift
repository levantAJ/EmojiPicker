//
//  EmojiPreviewer.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiPreviewable {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat, isDarkMode: Bool, completion: ((String) -> Void)?)
    func hide()
}

final class EmojiPreviewer: UIView {
    @IBOutlet weak var singleEmojiWrapperView: UIView!
    @IBOutlet weak var singleEmojiImageView: UIImageView!
    @IBOutlet weak var singleEmojiLabel: UILabel!
    
    @IBOutlet weak var multipleEmojisWrapperView: UIView!
    @IBOutlet weak var multipleEmojisLeftImageView: UIImageView!
    @IBOutlet weak var multipleEmojisCenterLeftImageView: UIImageView!
    @IBOutlet weak var multipleEmojisAnchorImageView: UIImageView!
    @IBOutlet weak var multipleEmojisAnchorImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var multipleEmojisCenterRightImageView: UIImageView!
    @IBOutlet weak var multipleEmojisRightImageView: UIImageView!
    @IBOutlet weak var multipleEmojisDefaultButton: UIButton!
    @IBOutlet weak var multipleEmojisWhiteButton: UIButton!
    @IBOutlet weak var multipleEmojisYellowButton: UIButton!
    @IBOutlet weak var multipleEmojisLightButton: UIButton!
    @IBOutlet weak var multipleEmojisDarkButton: UIButton!
    @IBOutlet weak var multipleEmojisBlackButton: UIButton!
    var selectedButton: UIButton?
    lazy var vibrator: Vibratable = Vibrator()
    var emojis: [String] = []
    var completion: ((String) -> Void)?
    
    static let shared: EmojiPreviewer = {
        let nib = UINib(nibName: "EmojiPreviewer", bundle: Bundle(for: EmojiPreviewer.self))
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! EmojiPreviewer
        view.backgroundColor = .clear
        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        return view
    }()
}

// MARK: - EmojiPreviewable

extension EmojiPreviewer: EmojiPreviewable {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat, isDarkMode: Bool, completion: ((String) -> Void)?) {
        self.emojis = emojis
        self.completion = completion
        if emojis.count == 1 {
            singleEmojiWrapperView.isHidden = false
            multipleEmojisWrapperView.isHidden = true
            setupView(for: emojis[0], sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
            completion?(emojis[0])
        } else if emojis.count == 6 {
            singleEmojiWrapperView.isHidden = true
            multipleEmojisWrapperView.isHidden = false
            setupView(for: emojis, sourceView: sourceView, sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
        }
    
        sourceView.addSubview(self)
    }
    
    func hide() {
        removeFromSuperview()
    }
}

// MARK: - User Interactions

extension EmojiPreviewer {
    @IBAction func multipleEmojisButtonTapped(_ button: UIButton) {
        guard button != selectedButton else { return }
        vibrator.vibrate()
        selectedButton?.backgroundColor = .clear
        button.backgroundColor = button.tintColor
        selectedButton = button
        switch button {
        case multipleEmojisDefaultButton:
            completion?(emojis[0])
        case multipleEmojisWhiteButton:
            completion?(emojis[1])
        case multipleEmojisYellowButton:
            completion?(emojis[2])
        case multipleEmojisLightButton:
            completion?(emojis[3])
        case multipleEmojisDarkButton:
            completion?(emojis[4])
        case multipleEmojisBlackButton:
            completion?(emojis[5])
        default:
            return
        }
    }
}

// MARK: - Privates

extension EmojiPreviewer {
    private func setupView(for emoji: String, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        singleEmojiImageView.image = image
        singleEmojiLabel.text = emoji
        singleEmojiLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
        let width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = width * image.size.height / image.size.width
        layoutIfNeeded()
        frame.size.width = singleEmojiWrapperView.frame.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
    }
    
    private func setupView(for emojis: [String], sourceView: UIView, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        multipleEmojisDefaultButton.titleLabel?.font = UIFont.systemFont(ofSize: emojiFontSize)
        multipleEmojisDefaultButton.backgroundColor = multipleEmojisDefaultButton.tintColor
        selectedButton = multipleEmojisDefaultButton
        multipleEmojisWhiteButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisWhiteButton.backgroundColor = .clear
        multipleEmojisYellowButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisYellowButton.backgroundColor = .clear
        multipleEmojisLightButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisLightButton.backgroundColor = .clear
        multipleEmojisDarkButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisDarkButton.backgroundColor = .clear
        multipleEmojisBlackButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisBlackButton.backgroundColor = .clear
        multipleEmojisDefaultButton.setTitle(emojis[0], for: .normal, animated: false)
        multipleEmojisWhiteButton.setTitle(emojis[1], for: .normal, animated: false)
        multipleEmojisYellowButton.setTitle(emojis[2], for: .normal, animated: false)
        multipleEmojisLightButton.setTitle(emojis[3], for: .normal, animated: false)
        multipleEmojisDarkButton.setTitle(emojis[4], for: .normal, animated: false)
        multipleEmojisBlackButton.setTitle(emojis[5], for: .normal, animated: false)
        
        let anchorImage = UIImage(named: isDarkMode ? "anchorDarkEmojiTag" : "anchorLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisAnchorImageView.image = anchorImage
        
        let leftImage = UIImage(named: isDarkMode ? "leftDarkEmojiTag" : "leftLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisLeftImageView.image = leftImage
        
        let rightImage = UIImage(named: isDarkMode ? "rightDarkEmojiTag" : "rightLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisRightImageView.image = rightImage
        
        let centerImage = UIImage(named: isDarkMode ? "centerDarkEmojiTag" : "centerLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisCenterLeftImageView.image = centerImage
        multipleEmojisCenterRightImageView.image = centerImage
        
        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        let width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = width * image.size.height / image.size.width
        layoutIfNeeded()
        frame.size.width = multipleEmojisWrapperView.frame.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
        multipleEmojisAnchorImageViewLeadingConstraint.constant = sourceRect.midX - frame.origin.x - multipleEmojisAnchorImageView.frame.width / 2
        var factor: CGFloat = 0
        if sourceRect.minX <= multipleEmojisLeftImageView.frame.width + multipleEmojisAnchorImageView.frame.width/3 {
            factor = abs(frame.minX) - multipleEmojisLeftImageView.frame.width
        } else if frame.minX <= 0 {
            factor = abs(frame.minX) + multipleEmojisLeftImageView.frame.width
        } else if sourceView.frame.width - sourceView.frame.maxX <= multipleEmojisRightImageView.frame.width + multipleEmojisAnchorImageView.frame.width/3 {
            factor = sourceView.frame.width - frame.maxX + multipleEmojisRightImageView.frame.width
        } else if frame.maxX >= sourceView.frame.width {
            factor = sourceView.frame.width - frame.maxX - multipleEmojisRightImageView.frame.width
        }
        frame.origin.x = frame.origin.x + factor
        multipleEmojisAnchorImageViewLeadingConstraint.constant = multipleEmojisAnchorImageViewLeadingConstraint.constant - factor
    }
}
