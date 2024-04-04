//
//  Updatable.swift
//  DrawingApp
//
//  Created by 조호근 on 3/26/24.
//

import Foundation

protocol Updatable {
    mutating func updateOpacity(for model: BaseRect, opacity: Opacity)
    mutating func updatePoint(for model: BaseRect, point: Point)
}
