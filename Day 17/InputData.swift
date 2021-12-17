//
//  InputData.swift
//  Day 17
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
target area: x=20..30, y=-10..-5
""".components(separatedBy: .newlines)

        case .challenge: return """
target area: x=143..177, y=-106..-71
""".components(separatedBy: .newlines)

        }
    }
}
