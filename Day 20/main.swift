//
//  main.swift
//  Day 20
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 20:")

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }
    var upLeft: Self { .init(x: x - 1, y: y - 1) }
    var upRight: Self { .init(x: x + 1, y: y - 1) }
    var downLeft: Self { .init(x: x - 1, y: y + 1) }
    var downRight: Self { .init(x: x + 1, y: y + 1) }

    var adjacent: [Self] { [upLeft, up, upRight, left, self, right, downLeft, down, downRight] }
}

extension Collection where Element: Comparable {
    func range() -> ClosedRange<Element> {
        precondition(count > 0)
        let sorted = self.sorted()
        return sorted.first! ... sorted.last!
    }
}

extension Dictionary where Key == Coordinate {
    var xRange: ClosedRange<Int> { keys.map { $0.x }.range() }
    var yRange: ClosedRange<Int> { keys.map { $0.y }.range() }

    func draw(default: Value) {
        let xRange = self.xRange
        let yRange = self.yRange
        for y in yRange {
            for x in xRange {
                let pixel = self[Coordinate(x: x, y: y), default: `default`]
                print(pixel, terminator: "")
            }
            print("")
        }
        print("")
    }
}

extension InputData {
    static func asGrid(_ rawValue: [String]) -> [Coordinate: String] {
        var map: [Coordinate: String] = [:]
        for y in 0 ..< rawValue.count {
            let line = Array(rawValue[y])
            for x in 0 ..< line.count {
                let c = Coordinate(x: x, y: y)
                map[c] = line[x] == "#" ? "1" : "0"
            }
        }
        return map
    }

    func loadData() -> (algo: [Character], image: [Coordinate: String]) {
        let algorithm = Array(self.data[0])
        let image = Self.asGrid(Array(self.data.dropFirst(2)))
        return (algorithm, image)
    }
}

enum Part1 {
    static func enhance(
        _ image: [Coordinate: String],
        using algorithm: [Character],
        default: String
    ) -> [Coordinate: String] {
        var grid: [Coordinate: String] = [:]
        for y in image.yRange.lowerBound - 1 ... image.yRange.upperBound + 1 {
            for x in image.xRange.lowerBound - 1 ... image.xRange.upperBound + 1 {
                let pixel = Coordinate(x: x, y: y)
                let subgrid = pixel.adjacent.map { image[$0, default: `default`] }
                let index = Int(subgrid.joined(), radix: 2)!
                grid[pixel] = algorithm[index] == "#" ? "1" : "0"
            }
        }
        return grid
    }

    static func run(_ source: InputData) {
        var (algorithm, image) = source.loadData()

        if source == .example { image.draw(default: " ") }
        for iter in 1 ... 2 {
            image = enhance(
                image,
                using: algorithm,
                default: (source == .example ? "0" : (iter % 2 == 1 ? "0" : "1"))
            )
            if source == .example { image.draw(default: " ") }
        }

        let lightPixels = image.values.filter { $0 == "1" }.count

        print("Part 1 (\(source)): \(lightPixels)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        var (algorithm, image) = source.loadData()

        for iter in 1 ... 50 {
            image = Part1.enhance(
                image,
                using: algorithm,
                default: (source == .example ? "0" : (iter % 2 == 1 ? "0" : "1"))
            )
        }

        let lightPixels = image.values.filter { $0 == "1" }.count

        print("Part 2 (\(source)): \(lightPixels)")
    }
}

InputData.allCases.forEach(Part2.run)
