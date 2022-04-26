//
//  Animations.swift
//  binkapp
//
//  Created by Nick Farrant on 06/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import UIKit

class LocalHeroAnimation {
    enum AnimationType: String {
        case shake
    }

    let animation: CAAnimation
    let type: AnimationType

    init(animation: CAAnimation, type: AnimationType) {
        self.animation = animation
        self.type = type
    }

    static let shake: LocalHeroAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.speed = 0.8
        animation.values = [0.9, 1.1, 0.9, 1.1, 0.95, 1.05, 0.98, 1.02, 1.0]
        return LocalHeroAnimation(animation: animation, type: .shake)
    }()
}

extension CALayer {
    func addLocalHeroAnimation(_ animation: LocalHeroAnimation) {
        add(animation.animation, forKey: animation.type.rawValue)
    }
}
