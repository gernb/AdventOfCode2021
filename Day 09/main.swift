//
//  main.swift
//  Day 09
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 09:")

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point: CustomDebugStringConvertible {
    var debugDescription: String { "\(x),\(y)" }
}

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map { line in
            Array(line).map(String.init).compactMap(Int.init)
        }

        let maxY = input.count
        let maxX = input[0].count
        var map: [Point: Int] = [:]
        for y in 0 ..< maxY {
            for x in 0 ..< maxX {
                map[Point(x: x, y: y)] = input[y][x]
            }
        }

        var lowestHeights: [Int] = []
        for y in 0 ..< maxY {
            for x in 0 ..< maxX {
                let height = map[Point(x: x, y: y)]!
                if height < map[Point(x: x-1, y: y), default: 10] &&
                    height < map[Point(x: x, y: y - 1), default: 10] &&
                    height < map[Point(x: x + 1, y: y), default: 10] &&
                    height < map[Point(x: x, y: y + 1), default: 10] {
                    lowestHeights.append(height)
                }
            }
        }
        let sum = lowestHeights.reduce(0, +) + lowestHeights.count

        print("Part 1 (\(source)): \(sum)")
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
