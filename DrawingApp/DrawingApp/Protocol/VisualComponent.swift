//
//  VisualComponent.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

protocol VisualComponent {
    func contains(_ point: Point) -> Bool
    func setOpacity(_ newOpacity: Opacity)
}
