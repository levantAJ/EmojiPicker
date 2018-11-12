//
//  EmojiPicker.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

public class EmojiPicker {
    public class var viewController: EmojiPickerViewController {
        let storyboard = UIStoryboard(name: "EmojiPicker", bundle: Bundle(for: EmojiPickerViewController.self))
        return storyboard.instantiateInitialViewController() as! EmojiPickerViewController
    }
}
