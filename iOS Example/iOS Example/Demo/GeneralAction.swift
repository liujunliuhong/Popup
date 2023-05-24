//
//  GeneralAction.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit
import Popup

public final class PopView1: UIView {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private let groupKey = "asd"

public final class GeneralAction: ModelAction {
    public func action() {
        let popView = PopView1()
        
        let backgroundTouchDismissAnimationProperty = AnimationProperty(duration: 2, options: .curveLinear)
        
        Popup.show(groupKey: groupKey,
                   popView: popView,
                   backgroundTouchDismissAnimationProperty: backgroundTouchDismissAnimationProperty) { popView in
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview { $0.snp.bottom }
                make.width.equalToSuperview().multipliedBy(0.7)
                make.height.equalTo(200)
            }
        } destinationConstraintClosure: { popView in
            let size = popView.frame.size
            popView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(size)
            }
        } dismissConstraintClosure: { popView in
            let size = popView.frame.size
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview { $0.snp.bottom }
                make.size.equalTo(size)
            }
        } completion: {
            print("completion")
        }
    }
}
