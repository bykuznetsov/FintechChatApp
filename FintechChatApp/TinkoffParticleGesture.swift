//
//  TinkoffParticleGesture.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 25.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class TinkoffParticleGesture {
    
    lazy var longTapGestureRecognizer: UILongPressGestureRecognizer = {
            let gestureRecognizer = UILongPressGestureRecognizer()
            gestureRecognizer.addTarget(self, action: #selector(handleLongTap))
            gestureRecognizer.minimumPressDuration = 0
            gestureRecognizer.cancelsTouchesInView = false
            return gestureRecognizer
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.addTarget(self, action: #selector(handlePan))
            gestureRecognizer.cancelsTouchesInView = false
            return gestureRecognizer
    }()
    
    @objc private func handleLongTap(sender: UILongPressGestureRecognizer) {
        
        tinkoffEmitterLayer.emitterPosition = sender.location(in: sender.view)
        
        if sender.state == .ended {
            tinkoffEmitterLayer.lifetime = 0
        } else if sender.state == .changed {
            
        } else if sender.state == .began {
            if let view = sender.view {
                showParticle(in: view)
            }
            tinkoffEmitterLayer.lifetime = 1.0
        }
        
    }

    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        
        tinkoffEmitterLayer.emitterPosition = sender.location(in: sender.view)
        
        if sender.state == .ended {
            tinkoffEmitterLayer.lifetime = 0
        } else if sender.state == .began {
            if let view = sender.view {
                showParticle(in: view)
            }
            tinkoffEmitterLayer.lifetime = 1.0
        }
        
    }
    
    lazy private var tinkoffEmitterCell: CAEmitterCell = {
        var tinkoffCell = CAEmitterCell()
        tinkoffCell.contents = UIImage(named: "tinkoffParticle")?.cgImage
        tinkoffCell.scale = 0.05
        tinkoffCell.scaleRange = 0
        tinkoffCell.emissionLongitude = 90
        tinkoffCell.emissionRange = .pi
        tinkoffCell.alphaSpeed = -0.5
        tinkoffCell.lifetime = 1
        tinkoffCell.birthRate = 8
        tinkoffCell.velocity = -50.0
        tinkoffCell.velocityRange = -10
        tinkoffCell.xAcceleration = 0
        tinkoffCell.yAcceleration = 0
        tinkoffCell.spin = -0.5
        tinkoffCell.spinRange = 1.0
        return tinkoffCell
    }()
    
    lazy private var tinkoffEmitterLayer: CAEmitterLayer = {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterSize = CGSize(width: 8, height: 8)
        particleEmitter.emitterShape = CAEmitterLayerEmitterShape.circle
        particleEmitter.beginTime = CACurrentMediaTime()
        particleEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
        particleEmitter.timeOffset = CFTimeInterval(arc4random_uniform(6) + 5)
        particleEmitter.emitterCells = [self.tinkoffEmitterCell]
        return particleEmitter
    }()
    
    private func showParticle(in view: UIView) {
        view.layer.addSublayer(tinkoffEmitterLayer)
    }
    
}
