//
//  Popup.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/22.
//

import Foundation
import UIKit

public typealias PopViewConstraintClosure = (_ popView: UIView) -> (Void)

public final class Popup {
    public static let defaultAnimationDuration: TimeInterval = 0.25
    public static let defaultAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    public static let defaultDimmedMaskColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public static let defaultDimmedMaskAlpha: CGFloat = 0.25
}

extension Popup {
    public static func show(groupKey: String,
                            popView: UIView,
                            dimmedMaskAlpha: CGFloat = Popup.defaultDimmedMaskAlpha,
                            animationProperty: AnimationProperty = .default,
                            backgroundTouchConfiguration: BackgroundTouchConfiguration = .default,
                            initialConstraintClosure: @escaping PopViewConstraintClosure,
                            destinationConstraintClosure: @escaping PopViewConstraintClosure,
                            dismissConstraintClosure: @escaping PopViewConstraintClosure,
                            completion: (() -> Void)? = nil) {
        
        guard let rootView = Popup.getRootViewController()?.view else { return }
        
        // backgroundView
        let backgroundView = BackgroundView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(backgroundView)
        
        let backgroundLeftConstraint = NSLayoutConstraint(item: backgroundView,
                                                          attribute: .left,
                                                          relatedBy: .equal,
                                                          toItem: rootView,
                                                          attribute: .left,
                                                          multiplier: 1.0,
                                                          constant: 0)
        let backgroundTopConstraint = NSLayoutConstraint(item: backgroundView,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: rootView,
                                                         attribute: .top,
                                                         multiplier: 1.0,
                                                         constant: 0)
        let backgroundRightConstraint = NSLayoutConstraint(item: backgroundView,
                                                           attribute: .right,
                                                           relatedBy: .equal,
                                                           toItem: rootView,
                                                           attribute: .right,
                                                           multiplier: 1.0,
                                                           constant: 0)
        let backgroundBottomConstraint = NSLayoutConstraint(item: backgroundView,
                                                            attribute: .bottom,
                                                            relatedBy: .equal,
                                                            toItem: rootView,
                                                            attribute: .bottom,
                                                            multiplier: 1.0,
                                                            constant: 0)
        rootView.addConstraints([backgroundLeftConstraint,
                                 backgroundTopConstraint,
                                 backgroundRightConstraint,
                                 backgroundBottomConstraint])
        
        rootView.setNeedsLayout()
        rootView.layoutIfNeeded()
        
        // dimmedView
        let dimmedView = DimmedView()
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(dimmedView)
        
        let dimmedLeftConstraint = NSLayoutConstraint(item: dimmedView,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: backgroundView,
                                                      attribute: .left,
                                                      multiplier: 1.0,
                                                      constant: 0)
        let dimmedTopConstraint = NSLayoutConstraint(item: dimmedView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: backgroundView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0)
        let dimmedRightConstraint = NSLayoutConstraint(item: dimmedView,
                                                       attribute: .right,
                                                       relatedBy: .equal,
                                                       toItem: backgroundView,
                                                       attribute: .right,
                                                       multiplier: 1.0,
                                                       constant: 0)
        let dimmedBottomConstraint = NSLayoutConstraint(item: dimmedView,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: backgroundView,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: 0)
        backgroundView.addConstraints([dimmedLeftConstraint,
                                       dimmedTopConstraint,
                                       dimmedRightConstraint,
                                       dimmedBottomConstraint])
        
        // gestureView
        let gestureView = GestureView()
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(gestureView)
        
        let gestureViewLeftConstraint = NSLayoutConstraint(item: gestureView,
                                                           attribute: .left,
                                                           relatedBy: .equal,
                                                           toItem: backgroundView,
                                                           attribute: .left,
                                                           multiplier: 1.0,
                                                           constant: 0)
        let gestureViewTopConstraint = NSLayoutConstraint(item: gestureView,
                                                          attribute: .top,
                                                          relatedBy: .equal,
                                                          toItem: backgroundView,
                                                          attribute: .top,
                                                          multiplier: 1.0,
                                                          constant: 0)
        let gestureViewRightConstraint = NSLayoutConstraint(item: gestureView,
                                                            attribute: .right,
                                                            relatedBy: .equal,
                                                            toItem: backgroundView,
                                                            attribute: .right,
                                                            multiplier: 1.0,
                                                            constant: 0)
        let gestureViewBottomConstraint = NSLayoutConstraint(item: gestureView,
                                                             attribute: .bottom,
                                                             relatedBy: .equal,
                                                             toItem: backgroundView,
                                                             attribute: .bottom,
                                                             multiplier: 1.0,
                                                             constant: 0)
        backgroundView.addConstraints([gestureViewLeftConstraint,
                                       gestureViewTopConstraint,
                                       gestureViewRightConstraint,
                                       gestureViewBottomConstraint])
        
        backgroundView.setNeedsLayout()
        backgroundView.layoutIfNeeded()
        
        if backgroundTouchConfiguration.enable {
            gestureView.tapClosure = {
                Popup.dismiss(groupKey: groupKey,
                              animationProperty: backgroundTouchConfiguration.animationProperty,
                              completion: backgroundTouchConfiguration.dismissClosure)
            }
        }
        
        // add popView
        backgroundView.addSubview(popView)
        
        //
        if animationProperty.animation {
            dimmedView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            
            initialConstraintClosure(popView)
            
            backgroundView.setNeedsLayout()
            backgroundView.layoutIfNeeded()
            
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                backgroundView.setNeedsLayout()
                backgroundView.layoutIfNeeded()
                
                dimmedView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            } completion: { _ in
                completion?()
            }
        } else {
            dimmedView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            
            dismissConstraintClosure(popView)
            
            completion?()
        }
        
        let viewPosition = ViewPosition(initialConstraintClosure: initialConstraintClosure,
                                        destinationConstraintClosure: destinationConstraintClosure,
                                        dismissConstraintClosure: dismissConstraintClosure)
        popView.popupPosition = viewPosition
        
        let info = Info(groupKey: groupKey,
                        mainPopView: popView,
                        backgroundView: backgroundView,
                        dimmedView: dimmedView,
                        gestureView: gestureView)
        
        rootView.append(info)
    }
    
    public static func updateDestination(groupKey: String,
                                         popView: UIView,
                                         animationProperty: AnimationProperty = .default,
                                         destinationConstraintClosure: @escaping PopViewConstraintClosure,
                                         completion: (() -> Void)? = nil) {
        guard let rootView = Popup.getRootViewController()?.view else { return }
        guard let info = rootView.getInfo(with: groupKey) else { return }
        guard let superView = popView.superview else { return } // backgroundView
        guard let popupPosition = popView.popupPosition else { return }
        
        var find = false
        for view in info.allPopViews {
            if view.identifier == popView.identifier {
                find = true
                break
            }
        }
        if !find {
            return
        }
        
        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        
        if animationProperty.animation {
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                superView.setNeedsLayout()
                superView.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        } else {
            destinationConstraintClosure(popView)
            completion?()
        }
        
        popupPosition.destinationConstraintClosure = destinationConstraintClosure
        
        popView.popupPosition = popupPosition
        
    }
    
    public static func updateDismiss(groupKey: String,
                                     popView: UIView,
                                     dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        guard let rootView = Popup.getRootViewController()?.view else { return }
        guard let info = rootView.getInfo(with: groupKey) else { return }
        guard let superView = popView.superview else { return }
        guard let popupPosition = popView.popupPosition else { return }
        
        var find = false
        for view in info.allPopViews {
            if view.identifier == popView.identifier {
                find = true
                break
            }
        }
        if !find {
            return
        }
        
        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        
        popupPosition.dismissConstraintClosure = dismissConstraintClosure
        popView.popupPosition = popupPosition
    }
    
    public static func insert(groupKey: String,
                              popView: UIView,
                              animationProperty: AnimationProperty = .default,
                              initialConstraintClosure: @escaping PopViewConstraintClosure,
                              destinationConstraintClosure: @escaping PopViewConstraintClosure,
                              dismissConstraintClosure: @escaping PopViewConstraintClosure,
                              completion: (() -> Void)? = nil) {
        guard let rootView = Popup.getRootViewController()?.view else { return }
        guard let info = rootView.getInfo(with: groupKey) else { return }
        
        // add popView
        info.backgroundView.addSubview(popView)
        
        //
        if animationProperty.animation {
            initialConstraintClosure(popView)
            
            info.backgroundView.setNeedsLayout()
            info.backgroundView.layoutIfNeeded()
            
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                info.backgroundView.setNeedsLayout()
                info.backgroundView.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        } else {
            destinationConstraintClosure(popView)
            completion?()
        }
        
        let viewPosition = ViewPosition(initialConstraintClosure: initialConstraintClosure,
                                        destinationConstraintClosure: destinationConstraintClosure,
                                        dismissConstraintClosure: dismissConstraintClosure)
        popView.popupPosition = viewPosition
        
        rootView.add(with: groupKey, otherPopView: popView)
    }
    
    
    public static func dismiss(groupKey: String,
                               animationProperty: AnimationProperty = .default,
                               completion: (() -> Void)? = nil) {
        guard let rootView = Popup.getRootViewController()?.view else { return }
        guard let info = rootView.getInfo(with: groupKey) else { return }
        
        func clear() {
            for popView in info.allPopViews {
                popView.removeFromSuperview()
            }
            info.gestureView.removeFromSuperview()
            info.dimmedView.removeFromSuperview()
            info.backgroundView.removeFromSuperview()
            rootView.remove(with: groupKey)
        }
        
        info.backgroundView.setNeedsLayout()
        info.backgroundView.layoutIfNeeded()
        
        if animationProperty.animation {
            for popView in info.allPopViews {
                let popupPosition = popView.popupPosition
                popupPosition?.dismissConstraintClosure(popView)
            }
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                info.backgroundView.setNeedsLayout()
                info.backgroundView.layoutIfNeeded()
                info.dimmedView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            } completion: { _ in
                clear()
                completion?()
            }
        } else {
            for popView in info.allPopViews {
                let popupPosition = popView.popupPosition
                popupPosition?.dismissConstraintClosure(popView)
            }
            info.dimmedView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            clear()
            completion?()
        }
    }
}

extension Popup {
    public static func getWindow() -> UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        }
        return nil
    }
    
    public static func getRootViewController() -> UIViewController? {
        return Popup.getWindow()?.rootViewController
    }
}
