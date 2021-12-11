//
//  InputData.swift
//  Day 11
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

import Foundation

enum InputData: String, CaseIterable {
    case example, challenge

    var data: [String] {
        switch self {

        case .example: return """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
""".components(separatedBy: .newlines)

        case .challenge: return """
7612648217
7617237672
2853871836
7214367135
1533365614
6258172862
5377675583
5613268278
8381134465
3445428733
""".components(separatedBy: .newlines)

        }
    }
}
