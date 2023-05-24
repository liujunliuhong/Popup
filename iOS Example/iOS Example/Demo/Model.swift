//
//  Model.swift
//  iOS Example
//
//  Created by dfsx6 on 2023/5/24.
//

import Foundation

public final class Model {
    public let title: String?
    public let action: ModelAction
    
    public init(title: String?, action: ModelAction) {
        self.title = title
        self.action = action
    }
}
