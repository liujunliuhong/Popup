//
//  PopupConstant.swift
//  Popup
//
//  Created by dfsx6 on 2024/3/13.
//

import Foundation
import UIKit

public typealias PopViewConstraintClosure = (_ popView: UIView) -> (Void)

public struct PopupConstant {
    public static let defaultAnimationDuration: TimeInterval = 0.25
    public static let defaultAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    public static let defaultDimmedMaskColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public static let defaultDimmedMaskAlpha: CGFloat = 0.25
}
