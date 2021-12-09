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

extension Point {
    var left: Point { Point(x: x-1, y: y) }
    var right: Point { Point(x: x+1, y: y) }
    var up: Point { Point(x: x, y: y-1) }
    var down: Point { Point(x: x, y: y+1) }
}

enum Part2 {
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

        var lowestPoints: [Point] = []
        for y in 0 ..< maxY {
            for x in 0 ..< maxX {
                let height = map[Point(x: x, y: y)]!
                if height < map[Point(x: x-1, y: y), default: 10] &&
                    height < map[Point(x: x, y: y - 1), default: 10] &&
                    height < map[Point(x: x + 1, y: y), default: 10] &&
                    height < map[Point(x: x, y: y + 1), default: 10] {
                    lowestPoints.append(Point(x: x, y: y))
                }
            }
        }

        var basinSizes: [Int] = []
        for lowPoint in lowestPoints {
            var visited: [Point] = []
            var queue = [lowPoint]
            while !queue.isEmpty {
                let p = queue.removeFirst()
                visited.append(p)
                for next in [p.up, p.left, p.right, p.down] {
                    if !visited.contains(next) && !queue.contains(next) && map[next, default: 9] < 9 {
                        queue.append(next)
                    }
                }
            }
            basinSizes.append(visited.count)
        }
        let product = basinSizes.sorted().suffix(3).reduce(1, *)

        print("Part 2 (\(source)): \(product)")
    }
}

InputData.allCases.forEach(Part2.run)
