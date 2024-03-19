//
//  Size.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

struct Size: Equatable {
    var width: Double
    var height: Double
    
    static func == (lhs: Size, rhs: Size) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}
