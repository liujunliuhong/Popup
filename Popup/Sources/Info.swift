//
//  Info.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

internal final class Info {
    internal let groupKey: String
    
    internal let mainPopView: UIView
    
    internal let backgroundView: UIView
    internal let dimmedView: UIView
    internal let gestureView: GestureView
    
    internal var otherPopViews: [UIView] = []
    
    internal var allPopViews: [UIView] {
        var popViews: [UIView] = []
        popViews.append(mainPopView)
        popViews.append(contentsOf: otherPopViews)
        return popViews
    }
    
    internal init(groupKey: String,
                  mainPopView: UIView,
                  backgroundView: UIView,
                  dimmedView: UIView,
                  gestureView: GestureView) {
        self.groupKey = groupKey
        self.mainPopView = mainPopView
        self.backgroundView = backgroundView
        self.dimmedView = dimmedView
        self.gestureView = gestureView
    }
}
