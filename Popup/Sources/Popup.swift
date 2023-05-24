//
//  Popup.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/22.
//

import Foundation
import UIKit
import SnapKit


public typealias PopViewConstraintClosure = (_ popView: UIView) -> (Void)


public final class Popup {
    public static let defaultAnimationDuration: TimeInterval = 0.25
    public static let defaultAnimationOptions: UIView.AnimationOptions = .curveEaseInOut
    public static let defaultDimmedMaskColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public static let defaultDimmedMaskAlpha: CGFloat = 0.25
}

extension Popup {
    private static func getWindow() -> UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        }
        return nil
    }
}

extension Popup {
    public static func show(groupKey: String,
                            popView: UIView,
                            dimmedMaskAlpha: CGFloat = Popup.defaultDimmedMaskAlpha,
                            animation: Bool = true,
                            animationProperty: AnimationProperty = .default,
                            shouldDismissOnBackgroundTouch: Bool = true,
                            backgroundTouchDismissAnimationProperty: AnimationProperty = .default,
                            initialConstraintClosure: @escaping PopViewConstraintClosure,
                            destinationConstraintClosure: @escaping PopViewConstraintClosure,
                            dismissConstraintClosure: @escaping PopViewConstraintClosure,
                            completion: (() -> Void)? = nil) {
        
        guard let window = Popup.getWindow() else { return }
        
        // backgroundView
        let backgroundView = UIView()
        window.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // contentView
        let contentView = ContentGestureView()
        window.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if shouldDismissOnBackgroundTouch {
            contentView.tapClosure = {
                Popup.dismiss(groupKey: groupKey,
                              animation: true,
                              animationProperty: backgroundTouchDismissAnimationProperty,
                              completion: nil)
            }
        }
        
        // add popView
        window.addSubview(popView)
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        //
        if animation {
            contentView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            
            initialConstraintClosure(popView)
            
            window.setNeedsLayout()
            window.layoutIfNeeded()
            
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                window.setNeedsLayout()
                window.layoutIfNeeded()
                
                contentView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            } completion: { _ in
                completion?()
            }
        } else {
            contentView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(dimmedMaskAlpha)
            
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
                        contentView: contentView)
        
        window.append(info)
    }
    
    
    public static func updateDestination(popView: UIView,
                                         animation: Bool = true,
                                         animationProperty: AnimationProperty = .default,
                                         destinationConstraintClosure: @escaping PopViewConstraintClosure,
                                         completion: (() -> Void)? = nil) {
        guard let window = Popup.getWindow() else { return }
        
        guard let popupPosition = popView.popupPosition else { return }
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        if animation {
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                window.setNeedsLayout()
                window.layoutIfNeeded()
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
    
    public static func updateDismiss(popView: UIView, dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        guard let window = Popup.getWindow() else { return }
        guard let popupPosition = popView.popupPosition else { return }
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        popupPosition.dismissConstraintClosure = dismissConstraintClosure
        popView.popupPosition = popupPosition
    }
    
    public static func insert(groupKey: String,
                              popView: UIView,
                              animation: Bool = true,
                              animationProperty: AnimationProperty = .default,
                              initialConstraintClosure: @escaping PopViewConstraintClosure,
                              destinationConstraintClosure: @escaping PopViewConstraintClosure,
                              dismissConstraintClosure: @escaping PopViewConstraintClosure,
                              completion: (() -> Void)? = nil) {
        
        guard let window = Popup.getWindow() else { return }
        
        // add popView
        window.addSubview(popView)
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        //
        if animation {
            initialConstraintClosure(popView)
            
            window.setNeedsLayout()
            window.layoutIfNeeded()
            
            destinationConstraintClosure(popView)
            
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                window.setNeedsLayout()
                window.layoutIfNeeded()
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
        
        window.add(with: groupKey, otherPopView: popView)
    }
    
    
    public static func dismiss(groupKey: String,
                               animation: Bool = true,
                               animationProperty: AnimationProperty = .default,
                               completion: (() -> Void)? = nil) {
        guard let window = Popup.getWindow() else { return }
        guard let info = window.getInfo(with: groupKey) else { return }
        
        func clear() {
            for popView in info.allPopViews {
                popView.removeFromSuperview()
            }
            info.contentView.removeFromSuperview()
            info.backgroundView.removeFromSuperview()
            window.remove(with: groupKey)
        }
        
        window.setNeedsLayout()
        window.layoutIfNeeded()
        
        if animation {
            for popView in info.allPopViews {
                let popupPosition = popView.popupPosition
                popupPosition?.dismissConstraintClosure(popView)
            }
            UIView.animate(withDuration: animationProperty.duration,
                           delay: 0,
                           options: animationProperty.options) {
                window.setNeedsLayout()
                window.layoutIfNeeded()
                info.contentView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            } completion: { _ in
                clear()
                completion?()
            }
        } else {
            for popView in info.allPopViews {
                let popupPosition = popView.popupPosition
                popupPosition?.dismissConstraintClosure(popView)
            }
            info.contentView.backgroundColor = Popup.defaultDimmedMaskColor.withAlphaComponent(0)
            clear()
            completion?()
        }
    }
}
