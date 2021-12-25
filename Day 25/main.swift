//
//  main.swift
//  Day 25
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 25:")

enum Square: Equatable {
    case empty
    case right
    case down
}

extension InputData {
    func loadMap() -> [[Square]] {
        self.data.map { line -> [Square] in
            Array(line).map {
                switch $0 {
                case ".": return .empty
                case ">": return .right
                case "v": return .down
                default: fatalError()
                }
            }
        }
    }
}

enum Part1 {
    static func draw(_ map: [[Square]]) {
        for y in map.indices {
            for x in map[y].indices {
                switch map[y][x] {
                case .empty: print(".", terminator: "")
                case .right: print(">", terminator: "")
                case .down: print("v", terminator: "")
                }
            }
            print("")
        }
        print("")
    }

    static func step(_ map: inout [[Square]]) -> Bool {
        var moved = false
        let maxX = map[0].count
        let maxY = map.count
        var newMap = map

        for y in 0 ..< maxY {
            for x in 0 ..< maxX {
                if map[y][x] == .right && map[y][(x + 1) % maxX] == .empty {
                    newMap[y][(x + 1) % maxX] = .right
                    newMap[y][x] = .empty
                    moved = true
                }
            }
        }
        map = newMap

        for y in 0 ..< maxY {
            for x in 0 ..< maxX {
                if map[y][x] == .down && map[(y + 1) % maxY][x] == .empty {
                    newMap[(y + 1) % maxY][x] = .down
                    newMap[y][x] = .empty
                    moved = true
                }
            }
        }
        map = newMap

        return moved
    }

    static func run(_ source: InputData) {
        var map = source.loadMap()
        var stepCount = 1
        while step(&map) {
            stepCount += 1
//            print(stepCount)
        }

        print("Part 1 (\(source)): \(stepCount)")
    }
}

InputData.allCases.forEach(Part1.run)
