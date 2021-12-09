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

func buildMap(from: [String]) -> [Point: Int] {
    var map: [Point: Int] = [:]
    for y in 0 ..< from.count {
        let line = Array(from[y])
        for x in 0 ..< line.count {
            let p = Point(x: x, y: y)
            map[p] = Int(String(line[x]))
        }
    }
    return map
}

func lowestPoints(in map: [Point: Int]) -> [Point] {
    map.keys.compactMap { point -> Point? in
        let height = map[point]!
        return height < map[point.left, default: 10] &&
            height < map[point.up, default: 10] &&
            height < map[point.right, default: 10] &&
            height < map[point.down, default: 10] ? point : nil
    }
}

func findBasin(from lowPoint: Point, with map: [Point: Int]) -> Set<Point> {
    var visited: Set<Point> = []
    var queue = [lowPoint]
    while !queue.isEmpty {
        let p = queue.removeFirst()
        visited.insert(p)
        for next in [p.up, p.left, p.right, p.down] {
            if !visited.contains(next) && !queue.contains(next) && map[next, default: 9] < 9 {
                queue.append(next)
            }
        }
    }
    return visited
}

enum Part2 {
    static func run(_ source: InputData) {
        let map = buildMap(from: source.data)
        let answer = lowestPoints(in: map)
            .map { findBasin(from: $0, with: map) }
            .map(\.count)
            .sorted()
            .suffix(3)
            .reduce(1, *)

        print("Part 2 (\(source)): \(answer)")
    }
}

InputData.allCases.forEach(Part2.run)
