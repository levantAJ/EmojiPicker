//
//  String.swift
//  EmojiPicker
//
//  Created by levantAJ on 12/11/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

extension String {
    var localized: String {
        let language = UserDefaults.standard.string(forKey: Constant.CurrentLanguage.currentLanguageKey)
        let bundle: Bundle
        if Constant.CurrentLanguage.language != language {
            let path = Bundle.main.path(forResource: language, ofType: "lproj")
            bundle = path == nil ? Bundle(for: EmojiPicker.self) : Bundle(path: path!)!
            Constant.CurrentLanguage.language = language
            Constant.CurrentLanguage.bundle = bundle
        } else {
            bundle = Constant.CurrentLanguage.bundle
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

extension Constant {
    struct CurrentLanguage {
        static var language: String? = nil
        static var bundle: Bundle = Bundle(for: EmojiPicker.self)
        static let currentLanguageKey = "com.levantAJ.EmojiPicker.currentLanguage"
    }
}
