//
//  main.swift
//  Day 17
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 17:")

// target area: x=20..30, y=-10..-5

extension InputData {
    func toRanges() -> (x: ClosedRange<Int>, y: ClosedRange<Int>) {
        let tokens = self.data[0].components(separatedBy: " ")
        let x = tokens[2].dropFirst(2).dropLast().components(separatedBy: "..")
        let y = tokens[3].dropFirst(2).components(separatedBy: "..")
        return (Int(x[0])!...Int(x[1])!, Int(y[0])!...Int(y[1])!)
    }
}

enum Part1 {
    struct Vector: Hashable {
        let x: Int
        let y: Int
    }

    static func launch(xVelocity: Int, yVelocity: Int, target: (x: ClosedRange<Int>, y: ClosedRange<Int>)) -> (targetHit: Bool, maxHeight: Int) {
        var xVelocity = xVelocity
        var yVelocity = yVelocity
        var maxHeight = 0
        var x = 0
        var y = 0
        while x <= target.x.upperBound && y >= target.y.lowerBound {
            if target.x.contains(x) && target.y.contains(y) {
                return (true, maxHeight)
            }
            x = x + xVelocity
            y = y + yVelocity
            maxHeight = max(maxHeight, y)
            if xVelocity > 0 {
                xVelocity -= 1
            }
            yVelocity -= 1
        }
        return (false, maxHeight)
    }

    static func run(_ source: InputData) {
        let input = source.toRanges()

        var results: [Vector: Int] = [:]
        for x in 0 ... 1000 {
            for y in 0 ... 1000 {
                let (targetHit, maxHeight) = launch(xVelocity: x, yVelocity: y, target: input)
                if targetHit {
                    results[Vector(x: x, y: y)] = maxHeight
                }
            }
        }

        let max = results.max(by: { $0.value < $1.value })
        print("Part 1 (\(source)): \(max)")
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
