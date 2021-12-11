//
//  main.swift
//  Day 11
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 11:")

struct Point: Hashable {
    let x: Int
    let y: Int

    var left: Self { .init(x: x - 1, y: y) }
    var up: Self { .init(x: x, y: y - 1) }
    var right: Self { .init(x: x + 1, y: y) }
    var down: Self { .init(x: x, y: y + 1) }
    var upLeft: Self { .init(x: x - 1, y: y - 1) }
    var upRight: Self { .init(x: x + 1, y: y - 1) }
    var downLeft: Self { .init(x: x - 1, y: y + 1) }
    var downRight: Self { .init(x: x + 1, y: y + 1) }

    var adjacent: [Self] {
        [upLeft, up, upRight, left, right, downLeft, down, downRight]
    }
}

extension InputData {
    func asMap() -> [Point: Int] {
        var map: [Point: Int] = [:]
        for y in 0 ..< self.data.count {
            let line = Array(self.data[y])
            for x in 0 ..< line.count {
                let p = Point(x: x, y: y)
                map[p] = Int(String(line[x]))
            }
        }
        return map
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        var map = source.asMap()

        var flashes = 0
        for _ in 1 ... 100 {
        // Increase each point by 1
        for p in map.keys {
            map[p]! += 1
        }
        // Flash anything greater than 9
        var flashed: Set<Point> = []
        var octopusFlashed = false
        repeat {
            octopusFlashed = false
            for p in map.keys {
                if map[p]! > 9 && !flashed.contains(p) {
                    flashed.insert(p)
                    octopusFlashed = true
                    flashes += 1
                    for adj in p.adjacent {
                        guard let val = map[adj] else { continue }
                        map[adj] = val + 1
                    }
                }
            }
        } while octopusFlashed
        // Reset anything that flashed
        for p in map.keys {
            if map[p]! > 9 {
                map[p]! = 0
            }
        }
        }

        print("Part 1 (\(source)): \(flashes)")
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
