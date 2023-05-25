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

private var identifierKey = "com.galaxy.popup.identifierKey"
extension UIView {
    internal var identifier: String {
        get {
            if let string = objc_getAssociatedObject(self, &identifierKey) as? String {
                return string
            } else {
                let identifier = UUID().uuidString
                objc_setAssociatedObject(self, &identifierKey, identifier, .OBJC_ASSOCIATION_COPY)
                return identifier
            }
        }
        set {
            objc_setAssociatedObject(self, &identifierKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}

private var infoKey = "com.galaxy.popup.infoKey"
extension UIView {
    fileprivate var infos: [Info] {
        get {
            return (objc_getAssociatedObject(self, &infoKey) as? [Info]) ?? []
        }
        set {
            objc_setAssociatedObject(self, &infoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var allInfos: [Info] {
        return infos
    }
    
    internal func append(_ info: Info) {
        var infos = self.infos
        infos.append(info)
        self.infos = infos
    }
    
    internal func getInfo(with groupKey: String) -> Info? {
        let infos = self.infos
        for info in infos {
            if info.groupKey == groupKey {
                return info
            }
        }
        return nil
    }
    
    internal func add(with groupKey: String, otherPopView: UIView) {
        var hasChange: Bool = false
        let infos = self.infos
        for info in infos {
            if info.groupKey == groupKey {
                info.otherPopViews.append(otherPopView)
                hasChange = true
                break
            }
        }
        if hasChange {
            self.infos = infos
        }
    }
    
    internal func remove(with groupKey: String) {
        var infos = self.infos
        for (i, info) in infos.enumerated() {
            if info.groupKey == groupKey {
                infos.remove(at: i)
                self.infos = infos
                break
            }
        }
    }
}
