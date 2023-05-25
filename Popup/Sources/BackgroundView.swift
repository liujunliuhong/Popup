//
//  BackgroundView.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/25.
//

import Foundation
import UIKit

internal final class BackgroundView: UIView {

    internal var tapClosure: (() -> Void)?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
