//
//  main.swift
//  Day 01
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 01:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.compactMap(Int.init)

//        let increaseCount = input
//            .dropFirst()
//            .enumerated()
//            .map { pair in
//                if pair.element - input[pair.offset] > 0 {
//                    return 1
//                } else {
//                    return 0
//                }
//            }
//            .reduce(0, +)
        let increaseCount = zip(input.dropFirst(), input)
            .filter { $0.0 > $0.1 }
            .count

        print("Part 1 (\(source)): \(increaseCount)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data.compactMap(Int.init)

//        let windowedInput = input
//            .dropLast(2)
//            .enumerated()
//            .map {
//                $0.element + input[$0.offset + 1] + input[$0.offset + 2]
//            }
//
//        let increaseCount = windowedInput
//            .dropFirst()
//            .enumerated()
//            .map { pair in
//                if pair.element - windowedInput[pair.offset] > 0 {
//                    return 1
//                } else {
//                    return 0
//                }
//            }
//            .reduce(0, +)

        let windows = zip(input, zip(input.dropFirst(1), input.dropFirst(2)))
            .map { $0.0 + $0.1.0 + $0.1.1 }
        let increaseCount = zip(windows.dropFirst(), windows)
            .filter { $0.0 > $0.1 }
            .count

        print("Part 2 (\(source)): \(increaseCount)")
    }
}

InputData.allCases.forEach(Part2.run)
