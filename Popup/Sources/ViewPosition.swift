//
//  ViewPosition.swift
//  Popup
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation
import UIKit

internal final class ViewPosition {
    internal var initialConstraintClosure: PopViewConstraintClosure
    internal var destinationConstraintClosure: PopViewConstraintClosure
    internal var dismissConstraintClosure: PopViewConstraintClosure
    
    internal init(initialConstraintClosure: @escaping PopViewConstraintClosure,
                  destinationConstraintClosure: @escaping PopViewConstraintClosure,
                  dismissConstraintClosure: @escaping PopViewConstraintClosure) {
        self.initialConstraintClosure = initialConstraintClosure
        self.destinationConstraintClosure = destinationConstraintClosure
        self.dismissConstraintClosure = dismissConstraintClosure
    }
}
