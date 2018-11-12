//
//  GroupCollectionViewCell.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

protocol GroupCollectionViewCellDelegate: class {
    func groupCollectionViewCell(_ cell: GroupCollectionViewCell, didSelect indexPath: IndexPath)
}

final class GroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var groupButton: UIButton!
    var indexPath: IndexPath!
    weak var delegate: GroupCollectionViewCellDelegate?
    
    var image: UIImage? {
        didSet {
            groupButton.tintColor = .darkGray
            groupButton.imageView?.contentMode = .scaleAspectFit
            groupButton.setImage(image, for: .normal)
        }
    }
}

// MARK: - User Interactions

extension GroupCollectionViewCell {
    @IBAction func groupButtonTapped(_ button: UIButton) {
        delegate?.groupCollectionViewCell(self, didSelect: indexPath)
    }
}

extension Constant {
    struct GroupCollectionViewCell {
        static let identifier = "GroupCollectionViewCell"
    }
}
