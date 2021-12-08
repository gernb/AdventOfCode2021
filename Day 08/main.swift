//
//  main.swift
//  Day 08
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 08:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data

        var count = 0
        for line in input {
            let io = line.components(separatedBy: " | ")
            let output = io[1].components(separatedBy: " ")
            count += output.filter {
                $0.count == 2 || $0.count == 4 || $0.count == 3 || $0.count == 7
            }.count
        }

        print("Part 1 (\(source)): \(count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

final class LCDNumber {
    var segments: [String: Int] = [:]

    init(_ rawValue: [String]) {
        var input = rawValue

        let one = input.first { $0.count == 2 }!
        segments[String(one.sorted())] = 1
        input.remove(at: input.firstIndex(of: one)!)

        let four = input.first { $0.count == 4 }!
        segments[String(four.sorted())] = 4
        input.remove(at: input.firstIndex(of: four)!)

        let seven = input.first { $0.count == 3 }!
        segments[String(seven.sorted())] = 7
        input.remove(at: input.firstIndex(of: seven)!)

        let eight = input.first { $0.count == 7 }!
        segments[String(eight.sorted())] = 8
        input.remove(at: input.firstIndex(of: eight)!)

        let n235 = input.filter { $0.count == 5 }
        let a = Set(n235[0])
        let b = Set(n235[1])
        let c = Set(n235[2])
        let horizontals = a.intersection(b).intersection(c)

        let three = String((Array(horizontals) + Array(one)).sorted())
        segments[three] = 3
        input.remove(at: input.firstIndex(where: { Set($0) == Set(three) })!)

        let nine = Array(Set(four).union(horizontals)).sorted()
        segments[String(nine)] = 9
        input.remove(at: input.firstIndex(where: { Set($0) == Set(nine) })!)

        let n06 = input.filter { $0.count == 6 }.map(Set.init)
        let six = n06.first { $0.intersection(horizontals).count == 3 }!
        segments[String(six.sorted())] = 6
        input.remove(at: input.firstIndex(where: { Set($0) == Set(six) })!)

        let zero = n06.first { $0.intersection(horizontals).count != 3 }!
        segments[String(zero.sorted())] = 0
        input.remove(at: input.firstIndex(where: { Set($0) == Set(zero) })!)

        let n25 = input.map(Set.init)
        let five = n25.first { $0.symmetricDifference(nine).count == 1 }!
        segments[String(five.sorted())] = 5
        input.remove(at: input.firstIndex(where: { Set($0) == five })!)

        let two = input.first!
        segments[String(two.sorted())] = 2
    }

    func decode(_ input: [String]) -> Int {
        var number = 0

        let thousands = String(input[0].sorted())
        number = segments[thousands]! * 1000

        let hundreds = String(input[1].sorted())
        number += segments[hundreds]! * 100

        let tens = String(input[2].sorted())
        number += segments[tens]! * 10

        let ones = String(input[3].sorted())
        number += segments[ones]!

        return number
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        var sum = 0
        for line in input {
            let parts = line.components(separatedBy: " | ")
            let number = LCDNumber(parts[0].components(separatedBy: " "))
            sum += number.decode(parts[1].components(separatedBy: " "))
        }

        print("Part 2 (\(source)): \(sum)")
    }
}

InputData.allCases.forEach(Part2.run)
