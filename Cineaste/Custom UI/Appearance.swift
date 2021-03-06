//
//  Appearance.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 26.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension UIColor {
    static let primaryOrange = #colorLiteral(red: 0.9176470588, green: 0.337254902, blue: 0.1882352941, alpha: 1)
    static let primaryDarkOrange = #colorLiteral(red: 0.7294117647, green: 0.2666666667, blue: 0.1490196078, alpha: 1)

    static let basicYellow = #colorLiteral(red: 0.9843137255, green: 0.8862745098, blue: 0.1803921569, alpha: 1)
    static let basicWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let basicBackground = #colorLiteral(red: 0.2549019608, green: 0.2901960784, blue: 0.3176470588, alpha: 1)
    static let safariBarTint = #colorLiteral(red: 0.1458641843, green: 0.157300925, blue: 0.1739156683, alpha: 1)

    static let accentText = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5019607843, alpha: 1)

    static let transparentBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
}

enum Appearance {
    static func setup() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .primaryOrange

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .basicWhite
        tabBar.barTintColor = .primaryOrange
        tabBar.unselectedItemTintColor = .basicBackground

        let whiteTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicWhite]
        let darkTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .selected)
        tabBarItem.setTitleTextAttributes(darkTextAttributes, for: .normal)

        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = .basicWhite
        searchBar.barTintColor = .primaryOrange

        //change color of cursor
        let searchField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.tintColor = .basicBackground
    }
}
