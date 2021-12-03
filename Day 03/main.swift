//
//  main.swift
//  Day 03
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 03:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map { Array($0) }

        var gammaRateArray = [String]()
        var epsilonRateArray = [String]()

        let bitCount = input[0].count
        for bit in 0 ..< bitCount {
            var zeroCount = 0
            var oneCount = 0
            input.forEach {
                if $0[bit] == "0" {
                    zeroCount += 1
                } else {
                    oneCount += 1
                }
            }
            if zeroCount > oneCount {
                gammaRateArray.append("0")
                epsilonRateArray.append("1")
            } else {
                assert(oneCount > zeroCount)
                gammaRateArray.append("1")
                epsilonRateArray.append("0")
            }
        }

        let gammaRate = Int(gammaRateArray.joined(), radix: 2)!
        let epsilonRate = Int(epsilonRateArray.joined(), radix: 2)!

        print("Part 1 (\(source)): gamma rate = \(gammaRate), epsilon rate = \(epsilonRate), answer = \(gammaRate * epsilonRate)")
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
