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


public typealias PopViewConstraintClosure = (_ popView: UIView) -> (Void)

public struct Popup {
    public static let defaultAnimationDuration: TimeInterval = 0.25
    public static let defaultAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    public static let defaultDimmedMaskColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public static let defaultDimmedMaskAlpha: CGFloat = 0.25
}

//extension Popup {
//    /// 某个key是否已经存在
//    public static func isExist(groupKey: String) -> Bool {
//        guard let rootView = Popup.getRootView() else {
//            return false
//        }
//        guard let info = rootView.getInfo(with: groupKey) else {
//            return false
//        }
//        return true
//    }
//    
//    
//    /// Show a popView
//    /// - Parameters:
//    ///   - groupKey: A unique identifier for managing all popViews.
//    ///   - popView: A popView
//    ///   - dimmedMaskAlpha: Dimmed mask alpha.
//    ///   - animationProperty: Show animation property.
//    ///   - backgroundTouchConfiguration: Background touch configuration.
//    ///   - initialConstraintClosure: Initial position.
//    ///   - destinationConstraintClosure: Destination position.
//    ///   - dismissConstraintClosure: Dismiss position.
//    ///   - completion: Show completion callback.
//    public static func show(groupKey: String,
//                            popView: UIView,
//                            dimmedMaskAlpha: CGFloat = Popup.defaultDimmedMaskAlpha,
//                            dimmedMaskColor: UIColor = Popup.defaultDimmedMaskColor,
//                            animationProperty: AnimationProperty = .default,
//                            backgroundTouchConfiguration: BackgroundTouchConfiguration = .default,
//                            initialConstraintClosure: @escaping PopViewConstraintClosure,
//                            destinationConstraintClosure: @escaping PopViewConstraintClosure,
//                            dismissConstraintClosure: @escaping PopViewConstraintClosure,
//                            completion: (() -> Void)? = nil) {
//        
//        guard let rootView = Popup.getRootView() else {
//            completion?()
//            return
//        }
//        
//        // backgroundView
//        let backgroundView = BackgroundView()
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        rootView.addSubview(backgroundView)
//        Popup.setFullScreenConstraints(with: backgroundView, superView: rootView)
//        
//        rootView.setNeedsLayout()
//        rootView.layoutIfNeeded()
//        
//        // dimmedView
//        let dimmedView = DimmedView()
//        dimmedView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.addSubview(dimmedView)
//        Popup.setFullScreenConstraints(with: dimmedView, superView: backgroundView)
//        
//        // gestureView
//        let gestureView = GestureView()
//        gestureView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.addSubview(gestureView)
//        Popup.setFullScreenConstraints(with: gestureView, superView: backgroundView)
//        
//        backgroundView.setNeedsLayout()
//        backgroundView.layoutIfNeeded()
//        
//        if backgroundTouchConfiguration.enable {
//            gestureView.tapClosure = {
//                Popup.dismiss(groupKey: groupKey,
//                              animationProperty: backgroundTouchConfiguration.animationProperty,
//                              completion: backgroundTouchConfiguration.dismissClosure)
//            }
//        }
//        
//        // add popView
//        backgroundView.addSubview(popView)
//        
//        //
//        if animationProperty.animation {
//            dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(0)
//            
//            initialConstraintClosure(popView)
//            
//            backgroundView.setNeedsLayout()
//            backgroundView.layoutIfNeeded()
//            
//            destinationConstraintClosure(popView)
//            
//            UIView.animate(withDuration: animationProperty.duration,
//                           delay: animationProperty.delay,
//                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
//                           initialSpringVelocity: animationProperty.initialSpringVelocity,
//                           options: animationProperty.options) {
//                backgroundView.setNeedsLayout()
//                backgroundView.layoutIfNeeded()
//                
//                dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
//            } completion: { _ in
//                completion?()
//            }
//        } else {
//            dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
//            
//            destinationConstraintClosure(popView)
//            
//            completion?()
//        }
//        
//        let viewPosition = ViewPosition(initialConstraintClosure: initialConstraintClosure,
//                                        destinationConstraintClosure: destinationConstraintClosure,
//                                        dismissConstraintClosure: dismissConstraintClosure)
//        popView.popupPosition = viewPosition
//        
//        let info = Info(groupKey: groupKey,
//                        mainPopView: popView,
//                        backgroundView: backgroundView,
//                        dimmedView: dimmedView,
//                        dimmedMaskColor: dimmedMaskColor,
//                        gestureView: gestureView)
//        
//        rootView.append(info)
//    }
//    
//    /// Update destination position.
//    /// - Parameters:
//    ///   - groupKey: A unique identifier for managing all popViews.
//    ///   - popView: The popView that needs to change its position.
//    ///   - animationProperty: Animation property.
//    ///   - destinationConstraintClosure: Destination position.
//    ///   - completion: Update completion callback.
//    public static func updateDestination(groupKey: String,
//                                         popView: UIView,
//                                         animationProperty: AnimationProperty = .default,
//                                         destinationConstraintClosure: @escaping PopViewConstraintClosure,
//                                         completion: (() -> Void)? = nil) {
//        guard let rootView = Popup.getRootView() else {
//            completion?()
//            return
//        }
//        guard let info = rootView.getInfo(with: groupKey) else {
//            completion?()
//            return
//        }
//        guard let backgroundView = popView.superview as? BackgroundView else {
//            completion?()
//            return
//        } // backgroundView
//        
//        guard let popupPosition = popView.popupPosition else {
//            completion?()
//            return
//        }
//        
//        var find = false
//        for view in info.allPopViews {
//            if view.identifier == popView.identifier {
//                find = true
//                break
//            }
//        }
//        if !find {
//            completion?()
//            return
//        }
//        
//        backgroundView.setNeedsLayout()
//        backgroundView.layoutIfNeeded()
//        
//        if animationProperty.animation {
//            destinationConstraintClosure(popView)
//            
//            UIView.animate(withDuration: animationProperty.duration,
//                           delay: animationProperty.delay,
//                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
//                           initialSpringVelocity: animationProperty.initialSpringVelocity,
//                           options: animationProperty.options) {
//                backgroundView.setNeedsLayout()
//                backgroundView.layoutIfNeeded()
//            } completion: { _ in
//                completion?()
//            }
//        } else {
//            destinationConstraintClosure(popView)
//            completion?()
//        }
//        
//        popupPosition.destinationConstraintClosure = destinationConstraintClosure
//        
//        popView.popupPosition = popupPosition
//        
//    }
//    
//    /// Update dismiss position.
//    /// - Parameters:
//    ///   - groupKey: A unique identifier for managing all popViews.
//    ///   - popView: The popView that needs to change its position.
//    ///   - dismissConstraintClosure: Dismiss position.
//    public static func updateDismiss(groupKey: String,
//                                     popView: UIView,
//                                     dismissConstraintClosure: @escaping PopViewConstraintClosure) {
//        guard let rootView = Popup.getRootView() else { return }
//        guard let info = rootView.getInfo(with: groupKey) else { return }
//        guard let backgroundView = popView.superview as? BackgroundView else { return }
//        guard let popupPosition = popView.popupPosition else { return }
//        
//        var find = false
//        for view in info.allPopViews {
//            if view.identifier == popView.identifier {
//                find = true
//                break
//            }
//        }
//        if !find {
//            return
//        }
//        
//        backgroundView.setNeedsLayout()
//        backgroundView.layoutIfNeeded()
//        
//        popupPosition.dismissConstraintClosure = dismissConstraintClosure
//        popView.popupPosition = popupPosition
//    }
//    
//    /// Insert a popView
//    /// - Parameters:
//    ///   - groupKey: A unique identifier for managing all popViews.
//    ///   - popView: The popView that needs to insert.
//    ///   - animationProperty: Animation property.
//    ///   - initialConstraintClosure: Initial position.
//    ///   - destinationConstraintClosure: Destination position.
//    ///   - dismissConstraintClosure: Dismiss position.
//    ///   - completion: Insert completion callback.
//    public static func insert(groupKey: String,
//                              popView: UIView,
//                              animationProperty: AnimationProperty = .default,
//                              initialConstraintClosure: @escaping PopViewConstraintClosure,
//                              destinationConstraintClosure: @escaping PopViewConstraintClosure,
//                              dismissConstraintClosure: @escaping PopViewConstraintClosure,
//                              completion: (() -> Void)? = nil) {
//        guard let rootView = Popup.getRootView() else {
//            completion?()
//            return
//        }
//        guard let info = rootView.getInfo(with: groupKey) else {
//            completion?()
//            return
//        }
//        
//        // add popView
//        info.backgroundView.addSubview(popView)
//        
//        //
//        if animationProperty.animation {
//            initialConstraintClosure(popView)
//            
//            info.backgroundView.setNeedsLayout()
//            info.backgroundView.layoutIfNeeded()
//            
//            destinationConstraintClosure(popView)
//            
//            UIView.animate(withDuration: animationProperty.duration,
//                           delay: animationProperty.delay,
//                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
//                           initialSpringVelocity: animationProperty.initialSpringVelocity,
//                           options: animationProperty.options) {
//                info.backgroundView.setNeedsLayout()
//                info.backgroundView.layoutIfNeeded()
//            } completion: { _ in
//                completion?()
//            }
//        } else {
//            destinationConstraintClosure(popView)
//            completion?()
//        }
//        
//        let viewPosition = ViewPosition(initialConstraintClosure: initialConstraintClosure,
//                                        destinationConstraintClosure: destinationConstraintClosure,
//                                        dismissConstraintClosure: dismissConstraintClosure)
//        popView.popupPosition = viewPosition
//        
//        rootView.add(with: groupKey, otherPopView: popView)
//    }
//    
//    /// Dismiss all popViews managed by groupKey.
//    /// - Parameters:
//    ///   - groupKey: A unique identifier for managing all popViews.
//    ///   - animationProperty: Animation property.
//    ///   - completion: Dismiss completion callback.
//    public static func dismiss(groupKey: String,
//                               animationProperty: AnimationProperty = .default,
//                               completion: (() -> Void)? = nil) {
//        guard let rootView = Popup.getRootView() else {
//            completion?()
//            return
//        }
//        guard let info = rootView.getInfo(with: groupKey) else {
//            completion?()
//            return
//        }
//        
//        func clear() {
//            for popView in info.allPopViews {
//                popView.removeFromSuperview()
//            }
//            info.gestureView.removeFromSuperview()
//            info.dimmedView.removeFromSuperview()
//            info.backgroundView.removeFromSuperview()
//            rootView.remove(with: groupKey)
//        }
//        
//        info.backgroundView.setNeedsLayout()
//        info.backgroundView.layoutIfNeeded()
//        
//        if animationProperty.animation {
//            for popView in info.allPopViews {
//                let popupPosition = popView.popupPosition
//                popupPosition?.dismissConstraintClosure(popView)
//            }
//            UIView.animate(withDuration: animationProperty.duration,
//                           delay: animationProperty.delay,
//                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
//                           initialSpringVelocity: animationProperty.initialSpringVelocity,
//                           options: animationProperty.options) {
//                info.backgroundView.setNeedsLayout()
//                info.backgroundView.layoutIfNeeded()
//                info.dimmedView.backgroundColor = info.dimmedMaskColor.withAlphaComponent(0)
//            } completion: { _ in
//                clear()
//                completion?()
//            }
//        } else {
//            for popView in info.allPopViews {
//                let popupPosition = popView.popupPosition
//                popupPosition?.dismissConstraintClosure(popView)
//            }
//            info.dimmedView.backgroundColor = info.dimmedMaskColor.withAlphaComponent(0)
//            clear()
//            completion?()
//        }
//    }
//}

//extension Popup {
//    private static func setFullScreenConstraints(with view: UIView, superView: UIView) {
//        let leftConstraint = NSLayoutConstraint(item: view,
//                                                attribute: .left,
//                                                relatedBy: .equal,
//                                                toItem: superView,
//                                                attribute: .left,
//                                                multiplier: 1.0,
//                                                constant: 0)
//        let topConstraint = NSLayoutConstraint(item: view,
//                                               attribute: .top,
//                                               relatedBy: .equal,
//                                               toItem: superView,
//                                               attribute: .top,
//                                               multiplier: 1.0,
//                                               constant: 0)
//        let rightConstraint = NSLayoutConstraint(item: view,
//                                                 attribute: .right,
//                                                 relatedBy: .equal,
//                                                 toItem: superView,
//                                                 attribute: .right,
//                                                 multiplier: 1.0,
//                                                 constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: view,
//                                                  attribute: .bottom,
//                                                  relatedBy: .equal,
//                                                  toItem: superView,
//                                                  attribute: .bottom,
//                                                  multiplier: 1.0,
//                                                  constant: 0)
//        superView.addConstraints([leftConstraint,
//                                  topConstraint,
//                                  rightConstraint,
//                                  bottomConstraint])
//    }
//}

//extension Popup {
//    private static func getWindow() -> UIWindow? {
//        if let window = UIApplication.shared.delegate?.window {
//            return window
//        }
//        return nil
//    }
//    
//    private static func getRootViewController() -> UIViewController? {
//        return Popup.getWindow()?.rootViewController
//    }
//    
//    private static func getRootView() -> UIView? {
//        return Popup.getWindow()
//        //return Popup.getRootViewController()?.view
//    }
//}
