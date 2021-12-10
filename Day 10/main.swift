//
//  main.swift
//  Day 10
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 10:")

let openingBraces = ["(", "[", "{", "<"]

let matchingBrace = [
    ")": "(",
    "]": "[",
    "}": "{",
    ">": "<",
]

let braceScore = [
    ")": 3,
    "]": 57,
    "}": 1197,
    ">": 25137,
]

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map { Array($0).map(String.init) }

        var score = 0
        for line in input {
            var stack: [String] = []
            for brace in line {
                if openingBraces.contains(brace) {
                    stack.append(brace)
                } else {
                    guard !stack.isEmpty else { break }
                    let top = stack.removeLast()
                    if matchingBrace[brace]! != top {
                        score += braceScore[brace]!
                        break
                    }
                }
            }
        }

        print("Part 1 (\(source)): \(score)")
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
