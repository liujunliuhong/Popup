//
//  UIView+Extension.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit
import ObjectiveC

private var popupPositionKey = "com.galaxy.popup.popupPositionKey"

extension UIView {
    
    internal var popupPosition: ViewPosition? {
        get {
            return objc_getAssociatedObject(self, &popupPositionKey) as? ViewPosition
        }
        set {
            objc_setAssociatedObject(self, &popupPositionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
