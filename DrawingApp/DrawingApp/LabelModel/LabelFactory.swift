//
//  LabelFactory.swift
//  DrawingApp
//
//  Created by 조호근 on 4/2/24.
//

import Foundation

protocol LabelFactoryProtocol {
    func createLabel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity) -> Label
}

class LabelFactory: LabelFactoryProtocol {
    private let idGenerator = IDGenerator()
    private let text = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Egestas tellus rutrum tellus pellentesque eu. Viverra justo nec ultrices dui sapien eget mi proin sed. Vel pretium lectus quam id leo. Molestie at elementum eu facilisis sed odio morbi quis commodo. Risus at ultrices mi tempus imperdiet nulla malesuada. In est ante in nibh mauris cursus mattis molestie a. Venenatis urna cursus eget nunc. Eget velit aliquet sagittis id consectetur purus ut. Amet consectetur adipiscing elit pellentesque habitant morbi tristique senectus. Consequat nisl vel pretium lectus quam id. Nisl vel pretium lectus quam id leo in vitae turpis. Purus faucibus ornare suspendisse sed. Amet mauris commodo quis imperdiet.
    """
    var sequence = 0
    
    func createLabel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity) -> Label {
        let uniqueID = idGenerator.generateUniqueRandomID()
        let words = text.components(separatedBy: " ")
        guard words.count > 5 else { return createLabel(size: size, point: point, backgroundColor: backgroundColor, opacity: opacity) }
        
        let startPosition = Int.random(in: 0...(words.count - 5))
        let selectedWords = words[startPosition..<(startPosition + 5)].joined(separator: " ")
        sequence += 1
        return Label(uniqueID: uniqueID, text: selectedWords, point: point, size: size, backgroundColor: backgroundColor, opacity: opacity, sequence: sequence)
    }
}


