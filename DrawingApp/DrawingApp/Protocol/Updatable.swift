//
//  Updatable.swift
//  DrawingApp
//
//  Created by 조호근 on 3/26/24.
//

import Foundation

protocol Updatable {
    mutating func updateOpacity(uniqueID: UniqueID, opacity: Opacity)
    mutating func updatePoint(uniqueID: UniqueID, point: Point)
}
