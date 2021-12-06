//
//  main.swift
//  Day 06
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 06:")

enum Part1 {
    static func run(_ source: InputData) {
        var fish = source.data

        for _ in 1 ... 80 {
            var newFish: [Int] = []
            for (idx, f) in fish.enumerated() {
                if f == 0 {
                    newFish.append(8)
                    fish[idx] = 6
                } else {
                    fish[idx] -= 1
                }
            }
            fish.append(contentsOf: newFish)
        }

        print("Part 1 (\(source)): \(fish.count)")
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
