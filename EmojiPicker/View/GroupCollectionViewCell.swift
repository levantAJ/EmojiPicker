//
//  GroupCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var groupButton: UIButton!
    
    var image: UIImage? {
        didSet {
            groupButton.tintColor = .darkGray
            groupButton.imageView?.contentMode = .scaleAspectFit
            groupButton.setImage(image, for: .normal)
        }
    }
}

extension Constant {
    struct GroupCollectionViewCell {
        static let identifier = "GroupCollectionViewCell"
    }
}
