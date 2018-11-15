//
//  EmojiPreviewer.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol EmojiPreviewable {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat, isDarkMode: Bool)
    func hide()
}

final class EmojiPreviewer: UIView {
    @IBOutlet weak var singleEmojiWrapperView: UIView!
    @IBOutlet var singleEmojiWrapperViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var singleEmojiImageView: UIImageView!
    @IBOutlet weak var singleEmojiLabel: UILabel!
    
    @IBOutlet weak var multipleEmojisWrapperView: UIView!
    @IBOutlet var multipleEmojisWrapperViewTrailingConstraint: NSLayoutConstraint!
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
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat, isDarkMode: Bool) {
        if emojis.count == 1 {
            singleEmojiWrapperView.isHidden = false
            multipleEmojisWrapperView.isHidden = true
            singleEmojiWrapperViewTrailingConstraint.isActive = true
            multipleEmojisWrapperViewTrailingConstraint.isActive = false
            setupView(for: emojis[0], sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
        } else if emojis.count == 6 {
            singleEmojiWrapperView.isHidden = true
            multipleEmojisWrapperView.isHidden = false
            singleEmojiWrapperViewTrailingConstraint.isActive = false
            multipleEmojisWrapperViewTrailingConstraint.isActive = true
            setupView(for: emojis, sourceView: sourceView, sourceRect: sourceRect, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
        }
    
        sourceView.addSubview(self)
    }
    
    func hide() {
//        removeFromSuperview()
    }
}

// MARK: - Privates

extension EmojiPreviewer {
    private func setupView(for emoji: String, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        frame.size.width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = frame.size.width * image.size.height / image.size.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
        singleEmojiImageView.image = image
        singleEmojiLabel.text = emoji
        singleEmojiLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
    }
    
    private func setupView(for emojis: [String], sourceView: UIView, sourceRect: CGRect, emojiFontSize: CGFloat, isDarkMode: Bool) {
        multipleEmojisDefaultButton.titleLabel?.font = UIFont.systemFont(ofSize: emojiFontSize)
        multipleEmojisWhiteButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisYellowButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisLightButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisDarkButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisBlackButton.titleLabel?.font = multipleEmojisDefaultButton.titleLabel?.font
        multipleEmojisDefaultButton.setTitle(emojis[0], for: .normal, animated: false)
        multipleEmojisWhiteButton.setTitle(emojis[1], for: .normal, animated: false)
        multipleEmojisYellowButton.setTitle(emojis[2], for: .normal, animated: false)
        multipleEmojisLightButton.setTitle(emojis[3], for: .normal, animated: false)
        multipleEmojisDarkButton.setTitle(emojis[4], for: .normal, animated: false)
        multipleEmojisBlackButton.setTitle(emojis[5], for: .normal, animated: false)
        
        let image = UIImage(named: isDarkMode ? "darkEmojiTag" : "lightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        let width = Constant.EmojiCollectionViewCell.size.width + 37
        frame.size.height = width * image.size.height / image.size.width
        frame.size.width = (emojiFontSize + 4) * CGFloat(emojis.count) + multipleEmojisLeftImageView.frame.width + multipleEmojisRightImageView.frame.width + 26.2
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 9
        layoutIfNeeded()
        multipleEmojisAnchorImageViewLeadingConstraint.constant = sourceRect.midX - frame.origin.x - multipleEmojisAnchorImageView.frame.width / 2
        var factor: CGFloat = 0
        if frame.minX <= 0 {
            factor = abs(frame.minX)
        } else if frame.maxX >= sourceView.frame.width {
            factor = sourceView.frame.width - frame.maxX + 1
        }
        frame.origin.x = frame.origin.x + factor
        multipleEmojisAnchorImageViewLeadingConstraint.constant = multipleEmojisAnchorImageViewLeadingConstraint.constant - factor
        
        let anchorImage = UIImage(named: isDarkMode ? "anchorDarkEmojiTag" : "anchorLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisAnchorImageView.image = anchorImage
        
        let leftImage = UIImage(named: isDarkMode ? "leftDarkEmojiTag" : "leftLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisLeftImageView.image = leftImage
        
        let rightImage = UIImage(named: isDarkMode ? "rightDarkEmojiTag" : "rightLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisRightImageView.image = rightImage
        
        let centerImage = UIImage(named: isDarkMode ? "centerDarkEmojiTag" : "centerLightEmojiTag", in: Bundle(for: EmojiPreviewer.self), compatibleWith: nil)!
        multipleEmojisCenterLeftImageView.image = centerImage
        multipleEmojisCenterRightImageView.image = centerImage
    }
}
