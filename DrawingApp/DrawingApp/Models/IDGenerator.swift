//
//  IDGenerator.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation

class IDGenerator {
    private var existingIDs = Set<String>()
    private let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
    
    func generateUniqueRandomID() -> String {
        var uniqueID: String
        repeat {
            uniqueID = generateRandomID()
        } while existingIDs.contains(uniqueID)
        
        existingIDs.insert(uniqueID)
        return uniqueID
    }
    
    private func generateRandomID() -> String {
        var segments = [String]()
            
        for _ in 0..<3 {
            let segment = (0..<3).map { _ in characters.randomElement()! }
            segments.append(String(segment))
        }
        
        return segments.joined(separator: "-")
    }
}
