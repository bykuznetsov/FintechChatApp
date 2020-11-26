//
//  ShakeAnimation.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 25.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ShakeAnimation {
    
    func startShaking(view: UIView) {
        
        view.layer.removeAnimation(forKey: "stopShaking")
        
        let animationXY = CABasicAnimation(keyPath: "position")
        animationXY.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y - 5))
        animationXY.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y + 5))
        animationXY.isCumulative = true
                
        let animationRotate = CABasicAnimation(keyPath: "transform.rotation.z")
        animationRotate.fromValue = NSNumber(value: Double.pi / 10)
        animationRotate.toValue = NSNumber(value: Double.pi / -10)
        animationRotate.isCumulative = true
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [animationXY, animationRotate]
        
        view.layer.add(group, forKey: "startShaking")

    }
    
    func stopShaking(view: UIView, completionHandler: @escaping () -> Void) {
        
        if let transform = view.layer.presentation()?.transform {
            view.layer.transform = transform
        }
        view.layer.removeAnimation(forKey: "startShaking")
        
        let animationXY = CABasicAnimation(keyPath: "position")
        animationXY.fromValue = view.layer.presentation()
        animationXY.toValue = NSValue(cgPoint: CGPoint(x: view.center.x, y: view.center.y))
        
        let animationRotate = CABasicAnimation(keyPath: "transform.rotation.z")
        animationRotate.fromValue = view.layer.presentation()
        animationRotate.toValue = NSNumber(value: 0)
        
        let group = CAAnimationGroup()
        group.autoreverses = false
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        group.animations = [animationXY, animationRotate]
        
        CATransaction.setCompletionBlock {
            completionHandler()
        }
        
        view.layer.add(group, forKey: "stopShaking")
        
    }
    
}
