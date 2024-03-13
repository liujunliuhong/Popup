//
//  UIView+Extension.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit
import ObjectiveC

private var infoKey = "com.galaxy.popup.infoKey"
extension UIView {
    internal var info: Info? {
        get {
            return objc_getAssociatedObject(self, &infoKey) as? Info
        }
        set {
            objc_setAssociatedObject(self, &infoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var allInfoKey = "com.galaxy.popup.allInfoKey"
extension UIView {
    fileprivate var allInfos: [Info] {
        get {
            return (objc_getAssociatedObject(self, &allInfoKey) as? [Info]) ?? []
        }
        set {
            objc_setAssociatedObject(self, &allInfoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal func add(info: Info) {
        var infos = allInfos
        infos.append(info)
        self.allInfos = infos
    }
    
    internal func removeInfo(key: String) {
        var infos = allInfos
        for (i, info) in infos.enumerated() {
            if info.key == key {
                infos.remove(at: i)
                self.allInfos = infos
                break
            }
        }
    }
    
    internal func getInfo(key: String) -> Info? {
        var infos = allInfos
        for info in infos {
            if info.key == key {
                return info
                break
            }
        }
        return nil
    }
}
