//
//  Opacity.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation

enum Opacity: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine, ten
    
    init?(value: Int) {
        self.init(rawValue: value)
    }
}


