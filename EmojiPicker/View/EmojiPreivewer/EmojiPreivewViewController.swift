//
//  EmojiPreviewerViewController.swift
//  EmojiPicker
//
//  Created by levantAJ on 15/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

final class EmojiPreviewerViewController: UIViewController {
    lazy var tagView: EmojiPreviewable = EmojiPreviewer.shared
    var sourceRect: CGRect = .zero
    var emojis: [String] = []
    var emojiFontSize: CGFloat = 29
    var isDarkMode = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagView.show(sourceView: view, sourceRect: sourceRect, emojis: emojis, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        tagView.hide()
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard touches.first?.view == view else { return }
        dismiss(animated: true, completion: nil)
        
    }
}
