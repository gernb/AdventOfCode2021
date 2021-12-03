//
//  main.swift
//  Day 03
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 03:")

func countBits(at position: Int, input: [[String.Element]]) -> (zeros: Int, ones: Int) {
    let zeroCount = input.filter { $0[position] == "0" }.count
    let oneCount = input.count - zeroCount
    return (zeroCount, oneCount)
}

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map { Array($0) }

        var gammaRateArray = [String]()
        var epsilonRateArray = [String]()

        let bitCount = input[0].count
        for bit in 0 ..< bitCount {
            let (zeroCount, oneCount) = countBits(at: bit, input: input)
            if zeroCount > oneCount {
                gammaRateArray.append("0")
                epsilonRateArray.append("1")
            } else {
                assert(oneCount != zeroCount)
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
        let input = source.data.map { Array($0) }

        var position = 0
        var o2Gen = input
        while o2Gen.count > 1 {
            let (zeroCount, oneCount) = countBits(at: position, input: o2Gen)
            if oneCount >= zeroCount {
                o2Gen = o2Gen.filter { $0[position] == "1" }
            } else {
                o2Gen = o2Gen.filter { $0[position] == "0" }
            }
            position += 1
        }
        let o2GenRating = Int(String(o2Gen.first!), radix: 2)!

        position = 0
        var co2Scrub = input
        while co2Scrub.count > 1 {
            let (zeroCount, oneCount) = countBits(at: position, input: co2Scrub)
            if zeroCount <= oneCount {
                co2Scrub = co2Scrub.filter { $0[position] == "0" }
            } else {
                co2Scrub = co2Scrub.filter { $0[position] == "1" }
            }
            position += 1
        }
        let co2ScrubRating = Int(String(co2Scrub.first!), radix: 2)!

        print("Part 2 (\(source)): oxygen generator rating = \(o2GenRating), CO2 scrubber rating = \(co2ScrubRating), answer = \(o2GenRating * co2ScrubRating)")
    }
}

InputData.allCases.forEach(Part2.run)
