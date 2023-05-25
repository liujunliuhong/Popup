//
//  BackgroundTouchConfiguration.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/25.
//

import Foundation


public final class BackgroundTouchConfiguration {
    public let enable: Bool
    public let animationProperty: AnimationProperty
    public let dismissClosure: (() -> Void)?
    
    public init(enable: Bool,
                animationProperty: AnimationProperty,
                dismissClosure: (() -> Void)?) {
        self.enable = enable
        self.animationProperty = animationProperty
        self.dismissClosure = dismissClosure
    }
    
    public static let `default` = BackgroundTouchConfiguration(enable: true,
                                                               animationProperty: .default,
                                                               dismissClosure: nil)
}
