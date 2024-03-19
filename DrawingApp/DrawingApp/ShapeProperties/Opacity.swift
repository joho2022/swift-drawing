//
//  Opacity.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation

struct Opacity: Equatable {
    let value: Int
    
    init?(value: Int) {
        guard (1...10).contains(value) else {
            return nil
        }
        self.value = value
    }
    
    static func == (lhs: Opacity, rhs: Opacity) -> Bool {
        return lhs.value == rhs.value
    }
}
