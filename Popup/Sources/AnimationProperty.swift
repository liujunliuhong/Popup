//
//  AnimationProperty.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

public struct AnimationProperty {
    public let duration: TimeInterval
    public let options: UIView.AnimationOptions
    
    public init(duration: TimeInterval = Popup.defaultAnimationDuration,
                options: UIView.AnimationOptions = Popup.defaultAnimationOptions) {
        self.duration = duration
        self.options = options
    }
    
    public static let `default` = AnimationProperty()
}
