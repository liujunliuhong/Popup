//
//  GeneralAction.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit
import Popup

fileprivate final class PopView1: UIView {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

private let groupKey = "aabbccdd"

public final class GeneralAction: ModelAction {
    public func action() {
        let popView = PopView1()
        
        let backgroundTouchConfiguration = BackgroundTouchConfiguration(enable: true, animationProperty: .init(animation: true, duration: 0.25)) {
            print("Background Touch Dismiss")
        }
        
        Popup.show(groupKey: groupKey,
                   popView: popView,
                   dimmedMaskColor: .orange,
                   animationProperty: .init(animation: true, options: [.curveLinear]),
                   backgroundTouchConfiguration: backgroundTouchConfiguration) { popView in
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview { $0.snp.bottom }
                make.width.equalToSuperview().multipliedBy(0.7)
                make.height.equalTo(400)
            }
        } destinationConstraintClosure: { popView in
            let size = popView.frame.size // you can get size
            popView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(size)
            }
        } dismissConstraintClosure: { popView in
            let size = popView.frame.size // you can get size
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
