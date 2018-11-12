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
    lazy var vibrator: Vibrating = Vibrator()
    
    var image: UIImage? {
        didSet {
            groupButton.tintColor = .darkGray
            groupButton.imageView?.contentMode = .scaleAspectFit
            groupButton.setImage(image, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            groupButton.backgroundColor = isSelected ? UIColor.lightGray.withAlphaComponent(0.5) : .clear
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        groupButton.layer.cornerRadius = groupButton.frame.width/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupButton.backgroundColor = .clear
    }
}

// MARK: - User Interactions

extension GroupCollectionViewCell {
    @IBAction func groupButtonTapped(_ button: UIButton) {
        isSelected = true
        vibrator.vibrate()
        delegate?.groupCollectionViewCell(self, didSelect: indexPath)
    }
}

extension Constant {
    struct GroupCollectionViewCell {
        static let identifier = "GroupCollectionViewCell"
    }
}
