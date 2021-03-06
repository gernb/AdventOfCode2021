//
//  main.swift
//  Day 07
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 07:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let min = input.min()!
        let max = input.max()!

        var sums: [Int: Int] = [:]
        for pos in min ... max {
            let sum = input.reduce(0) { $0 + abs(pos - $1) }
            sums[pos] = sum
        }

        let minSum = sums.min { $0.value < $1.value }

        print("Part 1 (\(source)): \(minSum!.value)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

func cost(from: Int, to: Int) -> Int {
    let distance = abs(from - to)
    guard distance > 0 else { return 0 }
    return (1 ... distance).reduce(0, +)
}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data
        let min = input.min()!
        let max = input.max()!

        var sums: [Int: Int] = [:]
        for pos in min ... max {
            let sum = input.reduce(0) { $0 + cost(from: $1, to: pos) }
            sums[pos] = sum
        }

        let minSum = sums.min { $0.value < $1.value }

        print("Part 2 (\(source)): \(minSum!.value)")
    }
}

InputData.allCases.forEach(Part2.run)
