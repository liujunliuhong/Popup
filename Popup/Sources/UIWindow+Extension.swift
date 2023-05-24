//
//  UIWindow+Extension.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

private var infoKey = "com.galaxy.popup.infoKey"

extension UIWindow {
    internal var infos: [Info] {
        get {
            return (objc_getAssociatedObject(self, &infoKey) as? [Info]) ?? []
        }
        set {
            objc_setAssociatedObject(self, &infoKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
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
        let infos = self.infos
        for info in infos {
            if info.groupKey == groupKey {
                info.otherPopViews.append(otherPopView)
                break
            }
        }
        self.infos = infos
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
