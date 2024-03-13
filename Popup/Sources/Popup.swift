//
//  Popup.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/22.
//

import Foundation
import UIKit

public struct PopupWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol PopupCompatible {}

extension PopupCompatible {
    public var popup: PopupWrapper<Self> {
        get { return PopupWrapper(self) }
        set { }
    }
}

extension UIView: PopupCompatible { }



public final class Popup {
    public enum ContainerType {
        case window
        case rootView
    }
}

extension Popup {
    public static func isExist(key: String,
                               containerType: Popup.ContainerType) -> Bool {
        guard let containerView = Popup.getContainerView(containerType: containerType) else {
            return false
        }
        let info = containerView.getInfo(key: key)        
        return info != nil
    }
    
    public static func show(key: String,
                            containerType: Popup.ContainerType,
                            popView: UIView,
                            dimmedMaskAlpha: CGFloat = PopupConstant.defaultDimmedMaskAlpha,
                            dimmedMaskColor: UIColor = PopupConstant.defaultDimmedMaskColor,
                            animationProperty: AnimationProperty = .default,
                            backgroundTouchConfiguration: BackgroundTouchConfiguration = .default,
                            initialConstraintClosure: @escaping PopViewConstraintClosure,
                            destinationConstraintClosure: @escaping PopViewConstraintClosure,
                            dismissConstraintClosure: @escaping PopViewConstraintClosure,
                            completion: (() -> Void)? = nil) {
        
        guard let containerView = Popup.getContainerView(containerType: containerType) else {
            return
        }
        
        popView.popup.show(on: containerView,
                           key: key,
                           dimmedMaskAlpha: dimmedMaskAlpha,
                           dimmedMaskColor: dimmedMaskColor,
                           animationProperty: animationProperty,
                           backgroundTouchConfiguration: backgroundTouchConfiguration,
                           initialConstraintClosure: initialConstraintClosure,
                           destinationConstraintClosure: destinationConstraintClosure,
                           dismissConstraintClosure: dismissConstraintClosure,
                           completion: completion)
    }
    
    public static func updateDestination(key: String,
                                         containerType: Popup.ContainerType,
                                         animationProperty: AnimationProperty = .default,
                                         destinationConstraintClosure: @escaping PopViewConstraintClosure,
                                         completion: (() -> Void)? = nil) {
        guard let containerView = Popup.getContainerView(containerType: containerType) else {
            return
        }
        
        guard let info = containerView.getInfo(key: key) else {
            return
        }
        
        info.popView?.popup.updateDestination(animationProperty: animationProperty,
                                              destinationConstraintClosure: destinationConstraintClosure,
                                              completion: completion)
    }
    
    public static func updateDismiss(key: String,
                                     containerType: Popup.ContainerType,
                                     dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        guard let containerView = Popup.getContainerView(containerType: containerType) else {
            return
        }
        
        guard let info = containerView.getInfo(key: key) else {
            return
        }
        
        info.popView?.popup.updateDismiss(dismissConstraintClosure: dismissConstraintClosure)
    }
    
    public static func dismiss(key: String,
                               containerType: Popup.ContainerType,
                               animationProperty: AnimationProperty = .default,
                               completion: (() -> Void)? = nil) {
        guard let containerView = Popup.getContainerView(containerType: containerType) else {
            return
        }
        
        guard let info = containerView.getInfo(key: key) else {
            return
        }
        
        info.popView?.popup.dismiss(animationProperty: animationProperty, completion: completion)
    }
}

extension Popup {
    private static func getContainerView(containerType: Popup.ContainerType) -> UIView? {
        let containerView: UIView?
        switch containerType {
            case .window:
                containerView = Popup.getWindow()
            case .rootView:
                containerView = Popup.getRootView()
        }
        return containerView
    }
    
    private static func getWindow() -> UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        }
        return nil
    }
    
    private static func getRootView() -> UIView? {
        return Popup.getWindow()?.rootViewController?.view
    }
}
