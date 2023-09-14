//
//  AnimationProperty.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

public struct AnimationProperty {
    public let animation: Bool
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let usingSpringWithDamping: CGFloat
    public let initialSpringVelocity: CGFloat
    public let options: UIView.AnimationOptions
    
    public init(animation: Bool,
                duration: TimeInterval = Popup.defaultAnimationDuration,
                delay: TimeInterval = 0,
                usingSpringWithDamping: CGFloat = 0,
                initialSpringVelocity: CGFloat = 0,
                options: UIView.AnimationOptions = Popup.defaultAnimationOptions) {
        self.animation = animation
        self.duration = duration
        self.delay = delay
        self.usingSpringWithDamping = usingSpringWithDamping
        self.initialSpringVelocity = initialSpringVelocity
        self.options = options
    }
    
    public static let `default` = AnimationProperty(animation: true)
}
