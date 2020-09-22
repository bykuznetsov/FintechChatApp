//
//  UIAlertControllerExtension.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 21.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    //Func which ignore famous Apple's bug (printing a constraint failed).
    func ignoreNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
