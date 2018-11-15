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

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let storyboard = UIStoryboard(name: "EmojiPicker", bundle: Bundle(for: EmojiPickerContentViewController.self))
        let emojiPickerVC = storyboard.instantiateViewController(withIdentifier: "EmojiPickerContentViewController") as! EmojiPickerContentViewController
        emojiPickerVC.delegate = self
        emojiPickerVC.sourceView = view
        emojiPickerVC.sourceRect = sourceRect
        emojiPickerVC.delegate = self
        emojiPickerVC.isDarkMode = isDarkMode
        emojiPickerVC.language = language
        emojiPickerVC.preferredContentSize = size
        present(emojiPickerVC, animated: true, completion: nil)
    }
}

// MARK: - EmojiPickerContentViewControllerDelegate

extension EmojiPickerViewController: EmojiPickerContentViewControllerDelegate {
    func emojiPickerViewControllerDidDimiss(_ controller: EmojiPickerContentViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func emojiPickerViewController(_ controller: EmojiPickerContentViewController, didSelect emoji: String) {
        delegate?.emojiPickerViewController(self, didSelect: emoji)
    }
}
