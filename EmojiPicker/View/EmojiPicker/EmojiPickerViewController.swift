//
//  EmojiPickerViewController.swift
//  EmojiPicker
//
//  Created by levantAJ on 15/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

public protocol EmojiPickerViewControllerDelegate: class {
    func emojiPickerViewController(_ controller: EmojiPickerViewController, didSelect emoji: String)
}

open class EmojiPickerViewController: UIViewController {
    open var sourceRect: CGRect = .zero
    open var permittedArrowDirections: UIPopoverArrowDirection = .any
    open var emojiFontSize: CGFloat = 29
    open var backgroundColor: UIColor? = UIColor.white.withAlphaComponent(0.5)
    open var darkModeBackgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.5)
    open var isDarkMode = false
    open var language: String?
    open var dismissAfterSelected = false
    open var size: CGSize = CGSize(width: 200, height: 300)
    open weak var delegate: EmojiPickerViewControllerDelegate?
    var emojiPopoverVC: EmojiPopoverViewController!
    lazy var emojiPreviewer: EmojiPreviewable = EmojiPreviewer.shared
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let storyboard = UIStoryboard(name: "EmojiPopover", bundle: Bundle(for: EmojiPopoverViewController.self))
        let emojiPopoverVC = storyboard.instantiateInitialViewController() as! EmojiPopoverViewController
        emojiPopoverVC.delegate = self
        emojiPopoverVC.sourceView = view
        emojiPopoverVC.sourceRect = sourceRect
        emojiPopoverVC.delegate = self
        emojiPopoverVC.isDarkMode = isDarkMode
        emojiPopoverVC.language = language
        emojiPopoverVC.preferredContentSize = size
        present(emojiPopoverVC, animated: true, completion: nil)
    }
}

// MARK: - EmojiPickerContentViewControllerDelegate

extension EmojiPickerViewController: EmojiPickerContentViewControllerDelegate {
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, presentEmojiPreviewer emojis: [String], sourceView: UIView) {
        emojiPreviewer.show(sourceView: view.window!, sourceRect: sourceView.convert(sourceView.bounds, to: view), emojis: emojis, emojiFontSize: emojiFontSize, isDarkMode: isDarkMode)
    }

    func emojiPickerViewControllerHideEmojiPreviewer(_ controller: EmojiPopoverViewController) {
        emojiPreviewer.hide()
    }       
    
    func emojiPickerViewControllerDidDimiss(_ controller: EmojiPopoverViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, didSelect emoji: String) {
        delegate?.emojiPickerViewController(self, didSelect: emoji)
    }
}
