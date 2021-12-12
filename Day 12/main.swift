//
//  main.swift
//  Day 12
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 12:")

final class Room {
    let name: String
    var connections: Set<Room> = []

    var isSmallRoom: Bool {
        name.lowercased() == name
    }

    init(name: String) {
        self.name = name
    }
}

extension Room: Equatable, Hashable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension InputData {
    func asRooms() -> (start: Room, end: Room) {
        var rooms: [String: Room] = [:]
        for line in self.data {
            let names = line.components(separatedBy: "-")
            let left = rooms[names[0], default: Room(name: names[0])]
            let right = rooms[names[1], default: Room(name: names[1])]
            left.connections.insert(right)
            right.connections.insert(left)
            rooms[left.name] = left
            rooms[right.name] = right
        }
        return (rooms["start"]!, rooms["end"]!)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let (start, end) = source.asRooms()

        var paths: [[Room]] = []
        var queue = [[start]]
        while !queue.isEmpty {
            let path = queue.removeFirst()
            let last = path.last!
            if last == end {
                paths.append(path)
                continue
            }
            for next in last.connections {
                if !next.isSmallRoom || !path.contains(next) {
                    queue.append(path + [next])
                }
            }
        }

        print("Part 1 (\(source)): \(paths.count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Room: CustomStringConvertible {
    var description: String { name }
}

enum Part2 {
    static func foo(_ path: [Room]) -> Int {
        let smallCaves = path.filter { $0.isSmallRoom && $0.name != "start" }
        for cave in smallCaves {
            let count = smallCaves.filter { $0 == cave }.count
            if count > 1 {
                return count
            }
        }
        return smallCaves.isEmpty ? 0 : 1
    }

    static func run(_ source: InputData) {
        let (start, end) = source.asRooms()

        var paths: [[Room]] = []
        var queue = [[start]]
        while !queue.isEmpty {
            let path = queue.removeFirst()
            let last = path.last!
            if last == end {
                paths.append(path)
                continue
            }
            for next in last.connections {
                if next == start {
                    continue
                }
                if next.isSmallRoom {
                    if foo(path) < 2 {
                        queue.append(path + [next])
                    } else if !path.contains(next) {
                        queue.append(path + [next])
                    }
                } else {
                    queue.append(path + [next])
                }
            }
        }

        print("Part 2 (\(source)): \(paths.count)")
    }
}

InputData.allCases.forEach(Part2.run)
