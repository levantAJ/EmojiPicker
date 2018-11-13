<p align="center" >
  <img src="icon.png" title="EmojiPicker logo" width='444' float=left>
</p>

[![Pod Version](https://cocoapod-badges.herokuapp.com/v/EmojiPicker/badge.png)](http://cocoadocs.org/docsets/EmojiPicker/)
[![Pod Platform](https://cocoapod-badges.herokuapp.com/p/EmojiPicker/badge.png)](http://cocoadocs.org/docsets/EmojiPicker/)
[![Pod License](https://cocoapod-badges.herokuapp.com/l/EmojiPicker/badge.png)](https://www.apache.org/licenses/LICENSE-2.0.html)

# EmojiPicker
This library to show a popover to pick emojis for iOS

<p align="center" >
  <img src="example.gif" title="EmojiPicker example" width='200' float=left>
</p>

## Requirements

- iOS 9.0 or later
- Xcode 9.0 or later

## Installation
There is a way to use EmojiPicker in your project:

- using CocoaPods

### Installation with CocoaPods

```
pod 'EmojiPicker', '1.0'
```
### Build Project

At this point your workspace should build without error. If you are having problem, post to the Issue and the
community can help you solve it.

## How To Use

```swift
import EmojiPicker

let emojiPickerVC = EmojiPicker.viewController
emojiPickerVC.sourceView = view
emojiPickerVC.sourceRect = targetView.frame
present(emojiPickerVC, animated: true, completion: nil)
```

- Delegate [EmojiPickerViewControllerDelegate](https://github.com/levantAJ/EmojiPicker/blob/master/EmojiPicker/View/EmojiPickerViewController.swift)
```swift
emojiPickerVC.delegate = self
```

- Change size:
```swift
emojiPickerVC.preferredContentSize = CGSize(width: 300, height: 400)
```

- Change Emojis font size, default is `31`:
```swift
emojiPickerVC.emojiFontSize = 31
```

- Dismiss dismiss picker after select an emoji, default is `false`:
```swift
emojiPickerVC.dismissAfterSelected = false
```

- Apply dark mode, defautl is `false`
```swift
emojiPickerVC.isDarkMode = false
```

- Background color in light mode, used when `isDarkMode` is `false`, default is `UIColor.white.withAlphaComponent(0.5)`
```swift
emojiPickerVC.backgroundColor = UIColor.white.withAlphaComponent(0.5)
```

- Background color in dark mode, used when `isDarkMode` is `true`, default is `UIColor.black.withAlphaComponent(0.5)`
```swift
emojiPickerVC.darkModeBackgroundColor = UIColor.white.withAlphaComponent(0.5)
```

- Change language, default is `nil` as system language

```swift
emojiPickerVC.language = "en"
```

## Author
- [Tai Le](https://github.com/levantAJ)

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Licenses

All source code is licensed under the [MIT License](https://raw.githubusercontent.com/levantAJ/EmojiPicker/master/LICENSE).
