//
//  main.swift
//  Day 22
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 22:")

struct Point: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    var z: Int

    static let zero: Self = .init(x: 0, y: 0, z: 0)

    var description: String { "(\(x), \(y), \(z))" }
}

//on x=-20..26,y=-36..17,z=-47..7

struct Step: Hashable {
    enum State: String, Equatable {
        case on, off
    }

    let state: State
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    let zRange: ClosedRange<Int>
}

extension Step {
    init(_ rawValue: String) {
        let tokens = rawValue.components(separatedBy: " ")
        self.state = State(rawValue: tokens[0])!
        let ranges = tokens[1].components(separatedBy: ",")
        var bounds = ranges[0].dropFirst(2).components(separatedBy: "..").compactMap(Int.init)
        self.xRange = min(bounds[0], bounds[1]) ... max(bounds[0], bounds[1])
        bounds = ranges[1].dropFirst(2).components(separatedBy: "..").compactMap(Int.init)
        self.yRange = min(bounds[0], bounds[1]) ... max(bounds[0], bounds[1])
        bounds = ranges[2].dropFirst(2).components(separatedBy: "..").compactMap(Int.init)
        self.zRange = min(bounds[0], bounds[1]) ... max(bounds[0], bounds[1])
    }
}

extension InputData {
    func asSteps() -> [Step] {
        self.data.map(Step.init)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let steps = source.asSteps()
        var cubes = Set<Point>()

        let allowedRange = Set(-50 ... 50)
        for step in steps {
            if !allowedRange.intersection(step.xRange).isEmpty &&
                !allowedRange.intersection(step.yRange).isEmpty &&
                !allowedRange.intersection(step.zRange).isEmpty {
                for x in max(-50, step.xRange.lowerBound) ... min(50, step.xRange.upperBound) {
                    for y in max(-50, step.yRange.lowerBound) ... min(50, step.yRange.upperBound) {
                        for z in max(-50, step.zRange.lowerBound) ... min(50, step.zRange.upperBound) {
                            if step.state == .on {
                                cubes.insert(Point(x: x, y: y, z: z))
                            } else {
                                cubes.remove(Point(x: x, y: y, z: z))
                            }
                        }
                    }
                }
            }
        }

        print("Part 1 (\(source)): \(cubes.count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Step {
    var pointCount: Int {
        xRange.count * yRange.count * zRange.count
    }

    func intersection(with step: Step) -> Step? {
        let x = Set(self.xRange).intersection(step.xRange)
        if x.isEmpty { return nil }
        let y = Set(self.yRange).intersection(step.yRange)
        if y.isEmpty { return nil }
        let z = Set(self.zRange).intersection(step.zRange)
        if z.isEmpty { return nil }

        return .init(state: .on, xRange: x.min()! ... x.max()!, yRange: y.min()! ... y.max()!, zRange: z.min()! ... z.max()!)
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let steps = source.asSteps()
        var cubeCounts = [Step: Int]()

        var counter = 0
        for step in steps {
            print(counter)
            counter += 1
            for (cube, count) in cubeCounts {
                if let intersection = cube.intersection(with: step) {
                    cubeCounts[intersection, default: 0] -= count
                }
            }

            if step.state == .on {
                cubeCounts[step, default: 0] += 1
            }
        }

        let answer = cubeCounts.map { $0.key.pointCount * $0.value }.reduce(0, +)

        print("Part 2 (\(source)): \(answer)")
    }
}

//InputData.allCases.forEach(Part2.run)
Part2.run(.challenge)
