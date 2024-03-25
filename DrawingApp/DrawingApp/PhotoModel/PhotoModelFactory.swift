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
    func createPhotoModel(imageData: Data, size: Size, point: Point, opacity: Opacity) -> PhotoModel {
        return PhotoModel(imageData: imageData, size: size, point: point, opacity: opacity)
    }
}
