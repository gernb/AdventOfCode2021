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
        "(": 1,
        "[": 2,
        "{": 3,
        "<": 4,
    ]

    enum Category {
        case corrupt(String)
        case incomplete([String])

        var isIncomplete: Bool {
            if case .incomplete = self {
                return true
            }
            return false
        }
    }

    static func parse(_ line: [String]) -> Category {
        var stack: [String] = []
        for brace in line {
            if openingBraces.contains(brace) {
                stack.append(brace)
            } else {
                guard !stack.isEmpty else { fatalError() }
                let top = stack.removeLast()
                if matchingBrace[brace]! != top {
                    return .corrupt(brace)
                }
            }
        }
        return .incomplete(stack)
    }

    static func run(_ source: InputData) {
        let input = source.data.map { Array($0).map(String.init) }

        let scores = input.map(parse)
            .filter(\.isIncomplete)
            .map { category -> Int in
                guard case .incomplete(let stack) = category else { fatalError() }
                return stack.reversed().reduce(0) { score, brace in
                    (score * 5) + braceScore[brace]!
                }
            }

        let answer = scores.sorted()[scores.count / 2]
        print("Part 2 (\(source)): \(answer)")
    }
}

InputData.allCases.forEach(Part2.run)
