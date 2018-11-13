//
//  EmojiPickerViewController.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import UIKit

public protocol EmojiPickerViewControllerDelegate: class {
    func emojiPickerViewController(_ controller: EmojiPickerViewController, didSelect emoji: String)
}

public class EmojiPickerViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    public var sourceRect: CGRect = .zero {
        didSet {
            popoverPresentationController?.sourceRect = sourceRect
        }
    }
    public var sourceView: UIView? {
        didSet {
            popoverPresentationController?.sourceView = sourceView
        }
    }
    public var permittedArrowDirections: UIPopoverArrowDirection = .any {
        didSet {
            popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        }
    }
    public var emojiFontSize: CGFloat = 31 {
        didSet {
            emojisCollectionView?.reloadData()
        }
    }
    public var backgroundColor: UIColor? = UIColor.white.withAlphaComponent(0.5) {
        didSet {
            changeDarkModeStyle()
        }
    }
    public var darkModeBackgroundColor: UIColor? = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            changeDarkModeStyle()
        }
    }
    public var isDarkMode = false {
        didSet {
            changeDarkModeStyle()
        }
    }
    public var dismissAfterSelected = false
    public var isEmojiVibrationEnabled = false
    public weak var delegate: EmojiPickerViewControllerDelegate?
    
    @IBOutlet weak var emojisCollectionView: UICollectionView!
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    @IBOutlet weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var groupTopLineView: UIView!
    var selectedGroupCell: GroupCollectionViewCell?
    lazy var viewModel: EmojiPickerViewModelProtocol = EmojiPickerViewModel(userDefaults: UserDefaults.standard)
    lazy var vibrator: Vibrating = Vibrator()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        popoverPresentationController?.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}

// MARK: - UICollectionViewDataSource

extension EmojiPickerViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == emojisCollectionView {
            return viewModel.numberOfSections
        }
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojisCollectionView {
            return viewModel.numberOfEmojis(section: section)
        }
        return viewModel.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.EmojiCollectionViewCell.identifier, for: indexPath) as! EmojiCollectionViewCell
            cell.emojiFontSize = emojiFontSize
            if let emojis = viewModel.emojis(at: indexPath) {
                cell.emojis = emojis
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.GroupCollectionViewCell.identifier, for: indexPath) as! GroupCollectionViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.isDarkMode = isDarkMode
        if let group = EmojiGroup(index: indexPath.item) {
            cell.image = UIImage(named: group.rawValue, in: Bundle(for: GroupCollectionViewCell.self), compatibleWith: nil)
        }
        if selectedGroupCell == nil {
            selectedGroupCell = cell
            selectedGroupCell?.isSelected = true
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension EmojiPickerViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojisCollectionView {
            return Constant.EmojiCollectionViewCell.size
        }
        return CGSize(width: max(collectionView.frame.width/CGFloat(viewModel.numberOfSections), 32), height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == emojisCollectionView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.EmojiHeaderView.identifier, for: indexPath) as! EmojiHeaderView
            if let group = EmojiGroup(index: indexPath.section) {
                headerView.title = group.name
            }
            return headerView
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.GroupHeaderView.identifier, for: indexPath)
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            guard let emoji = viewModel.emojis(at: indexPath)?.first else { return }
            if isEmojiVibrationEnabled {
                vibrator.vibrate()
            }
            delegate?.emojiPickerViewController(self, didSelect: emoji)
            viewModel.select(emoji: emoji)
            if dismissAfterSelected {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension EmojiPickerViewController {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        selectCurrentGroupCell()
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectCurrentGroupCell()
    }
}

// MARK: - GroupCollectionViewCellDelegate

extension EmojiPickerViewController: GroupCollectionViewCellDelegate {
    func groupCollectionViewCell(_ cell: GroupCollectionViewCell, didSelect indexPath: IndexPath) {
        selectedGroupCell?.isSelected = false
        selectedGroupCell = cell
        selectedGroupCell?.isSelected = true
        if indexPath.item == 0 {
            emojisCollectionView.scrollRectToVisible(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)), animated: true)
        } else if let attributes = emojisCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.item)) {
            emojisCollectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - emojisCollectionView.contentInset.top), animated: true)
        }
    }
}

// MARK: - Privates

extension EmojiPickerViewController {
    private func setupViews() {
        emojisCollectionView.delegate = self
        emojisCollectionView.dataSource = self
        groupsCollectionView.delegate = self
        groupsCollectionView.dataSource = self
        
        var nib = UINib(nibName: Constant.EmojiCollectionViewCell.identifier, bundle: Bundle(for: EmojiCollectionViewCell.self))
        emojisCollectionView.register(nib, forCellWithReuseIdentifier: Constant.EmojiCollectionViewCell.identifier)
        nib = UINib(nibName: Constant.EmojiHeaderView.identifier, bundle: Bundle(for: EmojiHeaderView.self))
        emojisCollectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.EmojiHeaderView.identifier)
        var layout = emojisCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: emojisCollectionView.frame.width, height: Constant.EmojiHeaderView.height)
        
        nib = UINib(nibName: Constant.GroupCollectionViewCell.identifier, bundle: Bundle(for: GroupCollectionViewCell.self))
        groupsCollectionView.register(nib, forCellWithReuseIdentifier: Constant.GroupCollectionViewCell.identifier)
        nib = UINib(nibName: Constant.GroupHeaderView.identifier, bundle: Bundle(for: GroupHeaderView.self))
        groupsCollectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.GroupHeaderView.identifier)
        layout = groupsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: 0, height: 0)
        
        changeDarkModeStyle()
    }
    
    private func changeDarkModeStyle() {
        popoverPresentationController?.backgroundColor = isDarkMode ? darkModeBackgroundColor : backgroundColor
        bottomVisualEffectView?.effect = UIBlurEffect(style: isDarkMode ? .dark : .light)
        groupTopLineView?.backgroundColor = UIColor(hexString: isDarkMode ? "#3d3d3d" : "#9d9d9d")?.withAlphaComponent(0.3)
    }
    
    private func selectCurrentGroupCell() {
        guard let emojiCell = emojisCollectionView.visibleCells.first,
            let indexPath = emojisCollectionView.indexPath(for: emojiCell),
            let groupCell = groupsCollectionView.cellForItem(at: IndexPath(item: indexPath.section, section: 0)) as? GroupCollectionViewCell else { return }
        selectedGroupCell?.isSelected = false
        selectedGroupCell = groupCell
        selectedGroupCell?.isSelected = true
    }
}
