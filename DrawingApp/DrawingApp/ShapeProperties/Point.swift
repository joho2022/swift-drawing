//
//  Point.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

struct Point: Equatable {
    private(set) var x: Double
    private(set) var y: Double
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
