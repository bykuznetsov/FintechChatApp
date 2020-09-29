//
//  UIViewControllerExtension.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 27.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit


extension UIViewController {
    //Method with initialization of View Controller (for Navigation between VC's)
    //Rule: .swift & .storyboard -> the same name
    private class func storyboardInstancePrivate() -> UIViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    class func storyboardInstance() -> UIViewController? {
        return storyboardInstancePrivate()
    }
}
