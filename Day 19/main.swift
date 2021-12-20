//
//  main.swift
//  Day 19
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 19:")

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    static let zero: Self = .init(x: 0, y: 0, z: 0)

    var description: String { "(\(x), \(y), \(z))" }

    func distance(to other: Self) -> Int {
        return abs(x - other.x) + abs(y - other.y) + abs(z - other.z)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    var allRotationsAndMirrors: [Self] {
        var result: [Coordinate] = []
        let perms = [x, y, z].permutations
        for c in perms {
            result.append(contentsOf: [
                Coordinate(x: c[0], y: c[1], z: c[2]),
                Coordinate(x: -1 * c[0], y: -1 * c[1], z: -1 * c[2]),
                Coordinate(x: -1 * c[0], y: c[1], z: c[2]),
                Coordinate(x: c[0], y: -1 * c[1], z: c[2]),
                Coordinate(x: c[0], y: c[1], z: -1 * c[2]),
                Coordinate(x: -1 * c[0], y: -1 * c[1], z: c[2]),
                Coordinate(x: c[0], y: -1 * c[1], z: -1 * c[2]),
                Coordinate(x: -1 * c[0], y: c[1], z: -1 * c[2]),
            ])
        }
        return result
    }
}

extension Coordinate {
    init(_ rawValue: String) {
        let tokens = rawValue.components(separatedBy: ",").compactMap(Int.init)
        self.x = tokens[0]
        self.y = tokens[1]
        self.z = tokens[2]
    }
}

struct Scanner {
    let id: Int
    let beacons: [Coordinate]
    var position: Coordinate = .zero
}

extension Scanner {
    init(_ rawValue: [String]) {
        let tokens = rawValue[0].components(separatedBy: " ")
        self.id = Int(tokens[2])!
        self.beacons = rawValue.dropFirst().map(Coordinate.init)
    }
}

extension InputData {
    var scanners: [Scanner] {
        self.data
            .split(separator: "")
            .map(Array.init)
            .map(Scanner.init)

    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let scanners = source.scanners

//        var count = scanners[0].beacons.count
//        for scanner in scanners.dropFirst() {
//            count += scanner.beacons.count - 12
//        }
//        print("Part 1 (\(source)): \(count)")

        var beacons = Set(scanners[0].beacons)
        var queue = scanners.dropFirst()
        while !queue.isEmpty {
            let scanner = queue.removeFirst()
            var foundOrientation = false
            orientations: for o in beacons.first!.allRotationsAndMirrors.indices {
                for beacon in beacons {
                    for var other in scanner.beacons {
                        var overlapping = Set<Coordinate>()
                        var nonoverlapping = Set<Coordinate>()
                        other = other.allRotationsAndMirrors[o]
                        let v = beacon - other
                        for var foo in scanner.beacons {
                            foo = foo.allRotationsAndMirrors[o] + v
                            if beacons.contains(foo) {
                                overlapping.insert(foo)
                            } else {
                                nonoverlapping.insert(foo)
                            }
                        }
                        if overlapping.count >= 12 {
                            beacons.formUnion(nonoverlapping)
                            print("found", scanner.id)
                            foundOrientation = true
                            break orientations
                        }
                    }
                }
            }
            if !foundOrientation {
                queue.append(scanner)
            }
        }
        print("Part 1 (\(source)): \(beacons.count)\n")
    }
}

//InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let scanners = source.scanners

        var scannerPositions = [
            0: Coordinate.zero
        ]
        var beacons = Set(scanners[0].beacons)
        var queue = scanners.dropFirst()
        while !queue.isEmpty {
            let scanner = queue.removeFirst()
            print("Searching \(scanner.id)...")
            var foundOrientation = false
            orientations: for o in beacons.first!.allRotationsAndMirrors.indices {
                for beacon in beacons {
                    for var other in scanner.beacons {
                        var overlapping = Set<Coordinate>()
                        var nonoverlapping = Set<Coordinate>()
                        other = other.allRotationsAndMirrors[o]
                        let v = beacon - other
                        for var foo in scanner.beacons {
                            foo = foo.allRotationsAndMirrors[o] + v
                            if beacons.contains(foo) {
                                overlapping.insert(foo)
                            } else {
                                nonoverlapping.insert(foo)
                            }
                        }
                        if overlapping.count >= 12 {
                            beacons.formUnion(nonoverlapping)
                            print("found", scanner.id)
                            foundOrientation = true
                            scannerPositions[scanner.id] = v
                            break orientations
                        }
                    }
                }
            }
            if !foundOrientation {
                queue.append(scanner)
            }
        }

        var scannerDistances: [Int] = []
        for pos1 in scannerPositions.values {
            for pos2 in scannerPositions.values {
                scannerDistances.append(pos1.distance(to: pos2))
            }
        }
        let answer = scannerDistances.max()!

        print("Part 2 (\(source)): \(answer)\n")
    }
}

InputData.allCases.forEach(Part2.run)

// MARK: - Utilities

extension Array {
    var permutations: [[Element]] {
        guard self.count > 1 else { return [self] }
        return self.enumerated().flatMap { item in
            return self.removing(elementAt: item.offset).permutations.map { [item.element] + $0 }
        }
    }

    func removing(elementAt index: Int) -> [Element] {
        var result = self
        result.remove(at: index)
        return result
    }
}
