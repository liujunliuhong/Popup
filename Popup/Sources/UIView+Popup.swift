//
//  UIView+Popup.swift
//  Popup
//
//  Created by dfsx6 on 2024/3/12.
//

import Foundation
import UIKit

extension PopupWrapper where Base: UIView {
    public func show(on containerView: UIView,
                     dimmedMaskAlpha: CGFloat = Popup.defaultDimmedMaskAlpha,
                     dimmedMaskColor: UIColor = Popup.defaultDimmedMaskColor,
                     animationProperty: AnimationProperty = .default,
                     backgroundTouchConfiguration: BackgroundTouchConfiguration = .default,
                     initialConstraintClosure: @escaping PopViewConstraintClosure,
                     destinationConstraintClosure: @escaping PopViewConstraintClosure,
                     dismissConstraintClosure: @escaping PopViewConstraintClosure,
                     completion: (() -> Void)? = nil) {
        
        let key = UUID().uuidString
        base.key = key
        
        // backgroundView
        let backgroundView = BackgroundView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(backgroundView)
        setFullScreenConstraints(with: backgroundView, superView: containerView)
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        // dimmedView
        let dimmedView = DimmedView()
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(dimmedView)
        setFullScreenConstraints(with: dimmedView, superView: backgroundView)
        
        // gestureView
        let gestureView = GestureView()
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(gestureView)
        setFullScreenConstraints(with: gestureView, superView: backgroundView)
        
        backgroundView.setNeedsLayout()
        backgroundView.layoutIfNeeded()
        
        func __tapDismiss() {
            dismiss(animationProperty: backgroundTouchConfiguration.animationProperty,
                    completion: backgroundTouchConfiguration.dismissClosure)
        }
        
        if backgroundTouchConfiguration.enable {
            gestureView.tapClosure = {
                __tapDismiss()
            }
        }
        
        // add popView
        backgroundView.addSubview(base)
        
        //
        if animationProperty.animation {
            dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(0)
            
            initialConstraintClosure(base)
            
            backgroundView.setNeedsLayout()
            backgroundView.layoutIfNeeded()
            
            destinationConstraintClosure(base)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: animationProperty.delay,
                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
                           initialSpringVelocity: animationProperty.initialSpringVelocity,
                           options: animationProperty.options) {
                backgroundView.setNeedsLayout()
                backgroundView.layoutIfNeeded()
                
                dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            } completion: { _ in
                completion?()
            }
        } else {
            dimmedView.backgroundColor = dimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            
            destinationConstraintClosure(base)
            
            completion?()
        }
        
        let viewPosition = ViewPosition(initialConstraintClosure: initialConstraintClosure,
                                        destinationConstraintClosure: destinationConstraintClosure,
                                        dismissConstraintClosure: dismissConstraintClosure)
        base.popupPosition = viewPosition
        
        
        let info = Info(containerView: containerView,
                        popView: base,
                        backgroundView: backgroundView,
                        dimmedView: dimmedView,
                        dimmedMaskColor: dimmedMaskColor,
                        gestureView: gestureView)
        
        containerView.add(info)
    }
    
    public func dismiss(animationProperty: AnimationProperty = .default,
                        completion: (() -> Void)? = nil) {
        
        guard let key = base.key else {
            completion?()
            return
        }
        
        guard let containerView = base.superview else {
            completion?()
            return
        }
        
        guard let info = containerView.getInfo(with: key) else {
            completion?()
            return
        }
        
        func clear() {
            info.popView.removeFromSuperview()
            info.gestureView.removeFromSuperview()
            info.dimmedView.removeFromSuperview()
            info.backgroundView.removeFromSuperview()
            containerView.remove(with: key)
        }
        
        info.backgroundView.setNeedsLayout()
        info.backgroundView.layoutIfNeeded()
        
        let popupPosition = info.popView.popupPosition
        
        if animationProperty.animation {
            
            popupPosition?.dismissConstraintClosure(base)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: animationProperty.delay,
                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
                           initialSpringVelocity: animationProperty.initialSpringVelocity,
                           options: animationProperty.options) {
                info.backgroundView.setNeedsLayout()
                info.backgroundView.layoutIfNeeded()
                info.dimmedView.backgroundColor = info.dimmedMaskColor.withAlphaComponent(0)
            } completion: { _ in
                clear()
                completion?()
            }
        } else {
            popupPosition?.dismissConstraintClosure(base)
            info.dimmedView.backgroundColor = info.dimmedMaskColor.withAlphaComponent(0)
            clear()
            completion?()
        }
    }
    
    public func updateDestination(animationProperty: AnimationProperty = .default,
                                  destinationConstraintClosure: @escaping PopViewConstraintClosure,
                                  completion: (() -> Void)? = nil) {
        guard let key = base.key else {
            completion?()
            return
        }
        
        guard let containerView = base.superview else {
            completion?()
            return
        }
        
        guard let info = containerView.getInfo(with: key) else {
            completion?()
            return
        }
        
        guard let backgroundView = base.superview as? BackgroundView else {
            completion?()
            return
        } // backgroundView
        
        guard let popupPosition = base.popupPosition else {
            completion?()
            return
        }
        
        backgroundView.setNeedsLayout()
        backgroundView.layoutIfNeeded()
        
        if animationProperty.animation {
            destinationConstraintClosure(base)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: animationProperty.delay,
                           usingSpringWithDamping: animationProperty.usingSpringWithDamping,
                           initialSpringVelocity: animationProperty.initialSpringVelocity,
                           options: animationProperty.options) {
                backgroundView.setNeedsLayout()
                backgroundView.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        } else {
            destinationConstraintClosure(base)
            completion?()
        }
        
        popupPosition.destinationConstraintClosure = destinationConstraintClosure
        
        base.popupPosition = popupPosition
        
    }
    
    public func updateDismiss(dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        
        guard let key = base.key else {
            return
        }
        
        guard let containerView = base.superview else {
            return
        }
        
        guard let info = containerView.getInfo(with: key) else {
            return
        }
        
        guard let backgroundView = base.superview as? BackgroundView else {
            return
        } // backgroundView
        
        guard let popupPosition = base.popupPosition else {
            return
        }
        
        backgroundView.setNeedsLayout()
        backgroundView.layoutIfNeeded()
        
        popupPosition.dismissConstraintClosure = dismissConstraintClosure
        base.popupPosition = popupPosition
    }
}

private func setFullScreenConstraints(with view: UIView, superView: UIView) {
    let leftConstraint = NSLayoutConstraint(item: view,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: .left,
                                            multiplier: 1.0,
                                            constant: 0)
    let topConstraint = NSLayoutConstraint(item: view,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: superView,
                                           attribute: .top,
                                           multiplier: 1.0,
                                           constant: 0)
    let rightConstraint = NSLayoutConstraint(item: view,
                                             attribute: .right,
                                             relatedBy: .equal,
                                             toItem: superView,
                                             attribute: .right,
                                             multiplier: 1.0,
                                             constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: view,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: superView,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0)
    superView.addConstraints([leftConstraint,
                              topConstraint,
                              rightConstraint,
                              bottomConstraint])
}
