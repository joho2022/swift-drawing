//
//  RGBColor.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

struct RGBColor {
    var red: Int
    var green: Int
    var blue: Int
    
    init(red: Int, green: Int, blue: Int) {
        self.red = max(0, min(255, red))
        self.green = max(0, min(255, green))
        self.blue = max(0, min(255, blue))
    }
}
