//
//  main.swift
//  Day 01
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 01:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.compactMap(Int.init)

        let increaseCount = input
            .dropFirst()
            .enumerated()
            .map { pair in
                if pair.element - input[pair.offset] > 0 {
                    return 1
                } else {
                    return 0
                }
            }
            .reduce(0, +)
        print("Part 1 (\(source)): \(increaseCount)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
