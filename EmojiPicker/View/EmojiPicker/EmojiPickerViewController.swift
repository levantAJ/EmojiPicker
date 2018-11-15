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
    var emojiPreviewerVC: EmojiPreviewerViewController!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        var storyboard = UIStoryboard(name: "EmojiPopover", bundle: Bundle(for: EmojiPopoverViewController.self))
        emojiPopoverVC = storyboard.instantiateInitialViewController() as? EmojiPopoverViewController
        storyboard = UIStoryboard(name: "EmojiPreviewer", bundle: Bundle(for: EmojiPreviewerViewController.self))
        emojiPreviewerVC = storyboard.instantiateInitialViewController() as? EmojiPreviewerViewController
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !emojiPopoverVC.isBeingPresented else { return }
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
        emojiPreviewerVC.sourceRect = sourceView.convert(sourceView.bounds, to: view)
        emojiPreviewerVC.emojis = emojis
        emojiPreviewerVC.emojiFontSize = emojiFontSize
        emojiPreviewerVC.isDarkMode = isDarkMode
        present(emojiPreviewerVC, animated: true, completion: nil)
    }

    func emojiPickerViewControllerHideEmojiPreviewer(_ controller: EmojiPopoverViewController) {
        emojiPreviewerVC.dismiss(animated: true, completion: nil)
    }       
    
    func emojiPickerViewControllerDidDimiss(_ controller: EmojiPopoverViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func emojiPickerViewController(_ controller: EmojiPopoverViewController, didSelect emoji: String) {
        delegate?.emojiPickerViewController(self, didSelect: emoji)
    }
}
