//
//  TagView.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol TagViewProtocol {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat)
    func hide()
}

final class TagView: UIView {
    static let shared = TagView()
}

// MARK: - TagViewProtocol

extension TagView: TagViewProtocol {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat) {
        let image = UIImage(named: "emoji-tag", in: Bundle(for: TagView.self), compatibleWith: nil)!
        frame.size.width = Constant.EmojiCollectionViewCell.size.width + 16
        frame.size.height = frame.size.width * image.size.height / image.size.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height - 2
        backgroundColor = .clear
        layer.zPosition = .greatestFiniteMagnitude
        let imageView = UIImageView(frame: bounds)
        imageView.image = image
        addSubview(imageView)
        
        let titleLabel = UILabel(frame: bounds)
        titleLabel.text = emojis.first
        titleLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.frame.origin.y = 6
        titleLabel.frame.size.width = bounds.width
        addSubview(titleLabel)
        
        sourceView.addSubview(self)
    }
    
    func hide() {
        removeFromSuperview()
    }
}
