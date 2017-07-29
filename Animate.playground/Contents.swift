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
        return Animation(duration: duration) { $0.alpha = 1 }
    }

    static func fadeOut(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) { $0.alpha = 0 }
    }

    static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) { $0.bounds.size = size }
    }

    static func move(byX x: CGFloat, y: CGFloat, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) {
            $0.center.x += x
            $0.center.y += y
        }
    }
}

public final class AnimationToken {
    private let view: UIView
    private let animations: [Animation]
    private let mode: AnimationMode
    private var isValid = true

    internal init(view: UIView, animations: [Animation], mode: AnimationMode) {
        self.view = view
        self.animations = animations
        self.mode = mode
    }

    deinit {
        perform {}
    }

    internal func perform(completionHandler: @escaping () -> Void) {
        guard isValid else {
            return
        }

        isValid = false

        switch mode {
        case .inSequence:
            view.performAnimations(animations, completionHandler: completionHandler)
        case .inParallel:
            view.performAnimationsInParallel(animations, completionHandler: completionHandler)
        }
    }
}

internal enum AnimationMode {
    case inSequence
    case inParallel
}

public func animate(_ tokens: [AnimationToken]) {
    guard !tokens.isEmpty else {
        return
    }

    var tokens = tokens
    let token = tokens.removeFirst()

    token.perform {
        animate(tokens)
    }
}

public func animate(_ tokens: AnimationToken...) {
    animate(tokens)
}

public extension UIView {
    @discardableResult func animate(_ animations: [Animation]) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inSequence
        )
    }

    @discardableResult func animate(_ animations: Animation...) -> AnimationToken {
        return animate(animations)
    }

    @discardableResult func animate(inParallel animations: [Animation]) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inParallel
        )
    }

    @discardableResult func animate(inParallel animations: Animation...) -> AnimationToken {
        return animate(inParallel: animations)
    }
}

internal extension UIView {
    func performAnimations(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }

        var animations = animations
        let animation = animations.removeFirst()

        UIView.animate(withDuration: animation.duration, animations: {
            animation.closure(self)
        }, completion: { _ in
            self.performAnimations(animations, completionHandler: completionHandler)
        })
    }

    func performAnimationsInParallel(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }

        let animationCount = animations.count
        var completionCount = 0

        let animationCompletionHandler = {
            completionCount += 1

            if completionCount == animationCount {
                completionHandler()
            }
        }

        for animation in animations {
            UIView.animate(withDuration: animation.duration, animations: {
                animation.closure(self)
            }, completion: { _ in
                animationCompletionHandler()
            })
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

// MARK: - View setup

let label = UILabel()
label.text = "Let's animate..."
label.sizeToFit()
label.center = view.center
label.alpha = 0
view.addSubview(label)

let button = UIButton(type: .system)
button.setTitle("...multiple views!", for: .normal)
button.sizeToFit()
button.center.x = view.center.x
button.center.y = label.frame.maxY + 50
button.alpha = 0
view.addSubview(button)

// MARK: - Performing animation

animate(
    label.animate(
        .fadeIn(duration: 3),
        .move(byX: 0, y: -50, duration: 3)
    ),
    button.animate(.fadeIn(duration: 3))
)
