//
//  CGRect+.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import Foundation

extension CGRect {
    func with(width: CGFloat) -> CGRect {
        return CGRect(x: maxX - width, y: minY, width: width, height: height)
    }
    
    func remaining(after rect: CGRect) -> CGRect {
        return CGRect(x: minX, y: minY, width: maxX - rect.width, height: height)
    }
}
