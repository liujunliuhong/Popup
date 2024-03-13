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
                     key: String = UUID().uuidString,
                     dimmedMaskAlpha: CGFloat = PopupConstant.defaultDimmedMaskAlpha,
                     dimmedMaskColor: UIColor = PopupConstant.defaultDimmedMaskColor,
                     animationProperty: AnimationProperty = .default,
                     backgroundTouchConfiguration: BackgroundTouchConfiguration = .default,
                     initialConstraintClosure: @escaping PopViewConstraintClosure,
                     destinationConstraintClosure: @escaping PopViewConstraintClosure,
                     dismissConstraintClosure: @escaping PopViewConstraintClosure,
                     completion: (() -> Void)? = nil) {
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
        
        
        let info = Info(key: key,
                        containerView: containerView,
                        popView: base,
                        backgroundView: backgroundView,
                        dimmedView: dimmedView,
                        dimmedMaskColor: dimmedMaskColor,
                        gestureView: gestureView,
                        position: viewPosition)
        
        base.info = info
        
        containerView.add(info: info)
    }
    
    public func dismiss(animationProperty: AnimationProperty = .default,
                        completion: (() -> Void)? = nil) {
        
        guard let info = base.info else {
            completion?()
            return
        }
        
        func clear() {
            info.gestureView.removeFromSuperview()
            info.dimmedView.removeFromSuperview()
            info.backgroundView.removeFromSuperview()
            info.containerView?.removeInfo(key: info.key)
            base.info = nil
            base.removeFromSuperview()
        }
        
        info.backgroundView.setNeedsLayout()
        info.backgroundView.layoutIfNeeded()
        
        if animationProperty.animation {
            info.position.dismissConstraintClosure(base)
            
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
            info.position.dismissConstraintClosure(base)
            info.dimmedView.backgroundColor = info.dimmedMaskColor.withAlphaComponent(0)
            clear()
            completion?()
        }
    }
    
    public func updateDestination(animationProperty: AnimationProperty = .default,
                                  destinationConstraintClosure: @escaping PopViewConstraintClosure,
                                  completion: (() -> Void)? = nil) {
        
        
        guard let info = base.info else {
            completion?()
            return
        }
        
        let backgroundView = info.backgroundView
        
        
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
        
        info.position.destinationConstraintClosure = destinationConstraintClosure
        
        base.info = info
    }
    
    public func updateDismiss(dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        
        guard let info = base.info else {
            return
        }
        
        info.position.dismissConstraintClosure = dismissConstraintClosure
        base.info = info
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
