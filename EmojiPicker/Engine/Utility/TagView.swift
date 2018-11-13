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
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    static let shared: TagView = {
        let view = TagView()
        view.backgroundColor = .clear
        view.layer.zPosition = .greatestFiniteMagnitude
        view.imageView = UIImageView(frame: view.bounds)
        view.addSubview(view.imageView)
        
        view.titleLabel = UILabel(frame: view.bounds)
        view.titleLabel.textAlignment = .center
        view.titleLabel.frame.origin.y = 15
        view.addSubview(view.titleLabel)
        return view
    }()
}

// MARK: - TagViewProtocol

extension TagView: TagViewProtocol {
    func show(sourceView: UIView, sourceRect: CGRect, emojis: [String], emojiFontSize: CGFloat) {
        let image = UIImage(named: "emoji-tag", in: Bundle(for: TagView.self), compatibleWith: nil)!
        frame.size.width = Constant.EmojiCollectionViewCell.size.width + 32
        frame.size.height = frame.size.width * image.size.height / image.size.width
        frame.origin.x = sourceRect.midX - frame.width/2
        frame.origin.y = sourceRect.minY - frame.height + sourceRect.height + 5
        imageView.frame = bounds
        imageView.image = image
        
        titleLabel.text = emojis.first
        titleLabel.font = UIFont.systemFont(ofSize: emojiFontSize)
        titleLabel.sizeToFit()
        titleLabel.frame.size.width = bounds.width
        
        sourceView.addSubview(self)
    }
    
    func hide() {
        removeFromSuperview()
    }
}
