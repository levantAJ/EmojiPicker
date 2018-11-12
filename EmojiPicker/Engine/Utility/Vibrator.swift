//
//  Vibrator.swift
//  EmojiPicker
//
//  Created by levantAJ on 13/11/18.
//

import UIKit

protocol Vibrating {
    func vibrate()
}

struct Vibrator {}

// MARK: - Vibrating

extension Vibrator: Vibrating {
    func vibrate() {
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
