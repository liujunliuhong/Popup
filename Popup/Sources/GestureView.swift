//
//  GestureView.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/25.
//

import UIKit

internal final class GestureView: UIView {

    internal var tapClosure: (() -> Void)?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        tapClosure?()
    }
}