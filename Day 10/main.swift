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

enum Part1 {
    static let braceScore = [
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    ]

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
    static let braceScore = [
        ")": 1,
        "]": 2,
        "}": 3,
        ">": 4,
    ]

    static let closingBrace = [
        "(": ")",
        "[": "]",
        "{": "}",
        "<": ">",
    ]

    static func run(_ source: InputData) {
        let input = source.data.map { Array($0).map(String.init) }

        var scores: [Int] = []
        for line in input {
            var stack: [String] = []
            var isCorrupt = false
            for brace in line {
                if openingBraces.contains(brace) {
                    stack.append(brace)
                } else {
                    guard !stack.isEmpty else { fatalError() }
                    let top = stack.removeLast()
                    if matchingBrace[brace]! != top {
                        isCorrupt = true
                        break
                    }
                }
            }
            guard !isCorrupt else { continue }
            var score = 0
            while !stack.isEmpty {
                let top = stack.removeLast()
                let match = closingBrace[top]!
                score = (score * 5) + braceScore[match]!
            }
            scores.append(score)
        }

        let answer = scores.sorted()[scores.count / 2]
        print("Part 2 (\(source)): \(answer)")
    }
}

InputData.allCases.forEach(Part2.run)
