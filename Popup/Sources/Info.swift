//
//  Info.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

internal final class Info {
    
    internal let containerView: UIView
    
    internal let popView: UIView
    
    internal let backgroundView: UIView
    internal let dimmedView: UIView
    internal let dimmedMaskColor: UIColor
    internal let gestureView: GestureView
    
    internal init(containerView: UIView,
                  popView: UIView,
                  backgroundView: UIView,
                  dimmedView: UIView,
                  dimmedMaskColor: UIColor,
                  gestureView: GestureView) {
        self.containerView = containerView
        self.popView = popView
        self.backgroundView = backgroundView
        self.dimmedView = dimmedView
        self.dimmedMaskColor = dimmedMaskColor
        self.gestureView = gestureView
    }
}
