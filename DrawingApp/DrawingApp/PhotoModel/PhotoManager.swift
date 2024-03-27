//
//  PhotoManager.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let photoSelected = Notification.Name("photoSelected")
    static let photoOpacityChanged = Notification.Name("photoOpacityChanged")
}

struct PhotoManager: Updatable {
    private(set) var photos = [PhotoModel]()
    
    func photo(at point: Point) -> PhotoModel? {
        for photo in photos {
            if photo.contains(point) {
                return photo
            }
        }
        return nil
    }
    
    mutating func addPhoto(_ photo: PhotoModel) {
        return photos.append(photo)
    }
    
    func createImageView(_ data: PhotoModel) {
        let imageView = UIImageView(frame: CGRect(x: data.point.x, y: data.point.y, width: data.size.width, height: data.size.height))
        
        if let image = UIImage(data: data.imageData) {
            imageView.image = image
        }
        imageView.alpha = CGFloat(data.opacity.rawValue) / 10.0
        
        NotificationCenter.default.post(name: .photoSelected, object: nil, userInfo: ["photoModel": data, "photoView": imageView])
    }
    
    mutating func updateOpacity(uniqueID: UniqueID, opacity: Opacity) {
        if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setOpacity(opacity)
            
            NotificationCenter.default.post(name: .photoOpacityChanged, object: nil, userInfo: ["uniqueID": uniqueID, "opacity": opacity])
        }
    }
    
    mutating func updatePoint(uniqueID: UniqueID, point: Point) {
        if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setPoint(point) 
        }
        
        NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["uniqueID": uniqueID, "point": point])
    }
    
}
