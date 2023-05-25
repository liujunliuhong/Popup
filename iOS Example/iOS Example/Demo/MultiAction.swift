//
//  MultiAction.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit
import SnapKit
import Popup

fileprivate final class PopView1: UIView {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let btn = UIButton(type: .custom)
        btn.setTitle("点我", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnAction() {
        Popup.updateDestination(popView: self) { popView in
            let size = popView.frame.size // you can get size
            popView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(100)
                make.size.equalTo(size)
            }
        }
        Popup.updateDismiss(popView: self) { popView in
            let size = popView.frame.size // you can get size
            popView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview { $0.snp.bottom }
                make.size.equalTo(size)
            }
        }
        
        let popView = PopView2()
        
        Popup.insert(groupKey: groupKey,
                     popView: popView) { popView in
            popView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview { $0.snp.right }
                make.width.height.equalTo(100)
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
                make.centerY.equalToSuperview()
                make.left.equalToSuperview { $0.snp.right }
                make.size.equalTo(size)
            }
        }
    }
}

fileprivate final class PopView2: UIView {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let groupKey = "xcvcxvcx"

public final class MultiAction: ModelAction {
    public func action() {
        let popView = PopView1()
        
        Popup.show(groupKey: groupKey,
                   popView: popView,
                   animationProperty: .init(animation: true, options: [.curveLinear])) { popView in
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview { $0.snp.bottom }
                make.width.equalToSuperview().multipliedBy(0.6)
                make.height.equalTo(200)
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
