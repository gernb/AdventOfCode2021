//
//  main.swift
//  Day 08
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 08:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data

        var count = 0
        for line in input {
            let io = line.components(separatedBy: " | ")
            let output = io[1].components(separatedBy: " ")
            count += output.filter {
                $0.count == 2 || $0.count == 4 || $0.count == 3 || $0.count == 7
            }.count
        }

        print("Part 1 (\(source)): \(count)")
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
