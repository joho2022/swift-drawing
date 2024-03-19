//
//  ClampedRGB.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation

//@propertyWrapper를 적용시키려 했는데 옵셔널 바인딩 할 것이 많아서 생성만 하였음. 구현하고 리팩토링할 때까지 보류
@propertyWrapper
struct ClampedRGB {
    private var value: Int?
    var wrappedValue: Int? {
        get { value }
        set {
            if let newValue = newValue, newValue >= 0 && newValue <= 255 {
                value = newValue
            } else {
                value = nil
            }
        }
    }

    init(wrappedValue: Int?) {
        if let wrappedValue = wrappedValue, wrappedValue >= 0 && wrappedValue <= 255 {
            self.value = wrappedValue
        } else {
            self.value = nil
        }
    }
}
