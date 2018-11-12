//
//  EmojiPickerViewController.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

public class EmojiPickerViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    public var sourceView: UIView?
    public var sourceRect: CGRect?
    public var permittedArrowDirections: UIPopoverArrowDirection = .any
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let storyboard = UIStoryboard(name: "EmojiPocker", bundle: Bundle(for: EmojiPickerContentViewController.self))
        let emojiPickerVC = storyboard.instantiateInitialViewController() as! EmojiPickerContentViewController
        emojiPickerVC.modalPresentationStyle = .popover
        emojiPickerVC.popoverPresentationController?.delegate = self
        emojiPickerVC.popoverPresentationController?.sourceView = sourceView
        emojiPickerVC.popoverPresentationController?.sourceRect = sourceRect ?? sourceView?.bounds ?? .zero
        emojiPickerVC.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToEmojiPicker" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController?.delegate = self
        }
    }
    
    private func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
