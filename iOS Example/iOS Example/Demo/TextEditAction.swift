//
//  TextEditAction.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import SnapKit
import Popup

fileprivate final class PopView1: UIView {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var t1: UITextField = {
        let t = UITextField()
        t.layer.borderWidth = 2.0
        t.layer.borderColor = UIColor.red.cgColor
        t.placeholder = "说点什么吧"
        return t
    }()
    
    private lazy var t2: UITextField = {
        let t = UITextField()
        t.layer.borderWidth = 2.0
        t.layer.borderColor = UIColor.orange.cgColor
        t.placeholder = "说点什么吧"
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(t1)
        addSubview(t2)
        t1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(40)
        }
        t2.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(t1.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private let groupKey = "dasdasdqweqw"

public final class TextEditAction: ModelAction {
    public func action() {
        let popView = PopView1()
        
        let backgroundTouchConfiguration = BackgroundTouchConfiguration(enable: true, animationProperty: .init(animation: true, duration: 0.25)) {
            print("Background Touch Dismiss")
        }
        
        popView.popup.show(on: UIApplication.shared.keyWindow!,
                           dimmedMaskColor: .orange,
                           animationProperty: .init(animation: true, options: [.curveLinear]),
                           backgroundTouchConfiguration: backgroundTouchConfiguration) { popView in
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview { $0.snp.bottom }
                make.width.equalToSuperview().multipliedBy(0.7)
            }
        } destinationConstraintClosure: { popView in
            let size = popView.frame.size // you can get size
            popView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-40)
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
