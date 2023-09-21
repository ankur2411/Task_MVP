//
//  Extension.swift
//  Task
//
//  Created by Ankur Verma on 20/09/23.
//

import Foundation
extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
