/**
 *  Animate
 *  Copyright (c) John Sundell 2017
 *  Licensed under the MIT license. See LICENSE file.
 */

import UIKit
import PlaygroundSupport

// MARK: - Framework

public struct Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
}

public extension Animation {
    static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.alpha = 1 })
    }

    static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.bounds.size = size })
    }
}

public extension UIView {
    func animate(_ animations: [Animation]) {
        guard !animations.isEmpty else {
            return
        }

        var animations = animations
        let animation = animations.removeFirst()

        UIView.animate(withDuration: animation.duration, animations: {
            animation.closure(self)
        }, completion: { _ in
            self.animate(animations)
        })
    }

    func animate(inParallel animations: [Animation]) {
        for animation in animations {
            UIView.animate(withDuration: animation.duration) {
                animation.closure(self)
            }
        }
    }
}

// MARK: - Playground setup

let view = UIView(frame: CGRect(
    x: 0, y: 0,
    width: 500, height: 500
))

view.backgroundColor = .white

PlaygroundPage.current.liveView = view

// MARK: - Performing the animation

let animationView = UIView(frame: CGRect(
    x: 0, y: 0,
    width: 50, height: 50
))

animationView.backgroundColor = .red
animationView.alpha = 0
view.addSubview(animationView)

animationView.animate(inParallel: [
    .fadeIn(duration: 3),
    .resize(to: CGSize(width: 200, height: 200), duration: 3)
])
