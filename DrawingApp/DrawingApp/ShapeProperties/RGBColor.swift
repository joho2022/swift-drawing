//
//  RGBColor.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation
import UIKit

struct RGBColor: Equatable {
    private(set) var red: Int
    private(set) var green: Int
    private(set) var blue: Int
    
    init?(red: Int, green: Int, blue: Int) {
        guard (0...255).contains(red),
              (0...255).contains(green),
              (0...255).contains(blue) else {
            return nil
        }
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    static func == (lhs: RGBColor, rhs: RGBColor) -> Bool {
        return lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue
    }
}
