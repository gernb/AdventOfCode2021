//
//  main.swift
//  Day 05
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

struct Point {
    let x: Int
    let y: Int
}

extension Point {
    init(rawValue: String) {
        let tokens = rawValue.components(separatedBy: ",")
        self.x = Int(tokens[0])!
        self.y = Int(tokens[1])!
    }
}

extension Point: CustomStringConvertible {
    var description: String { "\(x),\(y)" }
}

struct Line {
    let start: Point
    let end: Point

    var isDiagonal: Bool {
        start.x != end.x && start.y != end.y
    }
    var isNotDiagonal: Bool {
        !isDiagonal
    }
}

extension Line {
    init(rawValue: String) {
        let tokens = rawValue.components(separatedBy: " -> ")
        self.start = .init(rawValue: tokens[0])
        self.end = .init(rawValue: tokens[1])
    }
}

extension Line: CustomStringConvertible {
    var description: String { "\(start) -> \(end)" }
}

// MARK: - Part 1

print("Day 05:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map(Line.init)

        let lines = input.filter(\.isNotDiagonal)
        let (allXs, allYs) = lines.reduce(into: (Set<Int>(), Set<Int>())) { result, line in
            result.0.insert(line.start.x)
            result.0.insert(line.end.x)
            result.1.insert(line.start.y)
            result.1.insert(line.end.y)
        }
        let maxX = allXs.max()!
        let maxY = allYs.max()!

        var grid = Array(repeating: Array(repeating: 0, count: maxY + 1), count: maxX + 1)
        for line in lines {
            let minX = min(line.start.x, line.end.x)
            let maxX = max(line.start.x, line.end.x)
            for x in minX ... maxX {
                let minY = min(line.start.y, line.end.y)
                let maxY = max(line.start.y, line.end.y)
                for y in minY ... maxY {
                    grid[x][y] += 1
                }
            }
        }

        var dangerCount = 0
        for x in 0 ..< grid.count {
            dangerCount += grid[x].filter { $0 > 1 }.count
        }

        print("Part 1 (\(source)): \(dangerCount)")
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
