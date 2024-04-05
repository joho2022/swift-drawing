//
//  PhotoModelFactory.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

protocol PhotoModelFactoryProtocol {
    func createPhotoModel(imageData: Data, size: Size, point: Point, opacity: Opacity) -> PhotoModel
}

class PhotoFactory: PhotoModelFactoryProtocol {
    private let idGenerator = IDGenerator()
    var sequence = 0
    func createPhotoModel(imageData: Data, size: Size, point: Point, opacity: Opacity) -> PhotoModel {
        let uniqueID = idGenerator.generateUniqueRandomID()
        sequence += 1
        return PhotoModel(uniqueID: uniqueID, imageData: imageData, size: size, point: point, opacity: opacity, sequence: sequence)
    }
}
