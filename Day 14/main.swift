//
//  main.swift
//  Day 14
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

import Foundation

// MARK: - Part 1

print("Day 14:")

extension InputData {
    func loadTemplateAndRules() -> ([String.Element], [[String.Element]: String.Element]) {
        let template = Array(self.data[0])
        let rules = self.data.dropFirst(2)
            .reduce(into: [[String.Element]: String.Element]()) { result, line in
                let tokens = line.components(separatedBy: " -> ")
                result[Array(tokens[0])] = tokens[1].first
            }
        return (template, rules)
    }
}

enum Part1 {
    static func step(_ template: inout [String.Element], with rules: [[String.Element]: String.Element]) {
        let pairs = zip(template, template.dropFirst())
        template = pairs.flatMap { pair in
            [pair.0, rules[[pair.0, pair.1]]!]
        } + [template.last!]
    }

    static func run(_ source: InputData) {
        var (template, rules) = source.loadTemplateAndRules()

        for _ in 1 ... 10 {
            step(&template, with: rules)
        }

        let set = NSCountedSet(array: template)
        let sorted = set.sorted { set.count(for: $0) > set.count(for: $1) }
        let diff = set.count(for: sorted.first!) - set.count(for: sorted.last!)

        print("Part 1 (\(source)): \(diff)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let (template, rules) = source.loadTemplateAndRules()

        var lettersCount = template.reduce(into: [Character: Int]()) { result, letter in
            result[letter, default: 0] += 1
        }
        var pairsCount = zip(template, template.dropFirst())
            .reduce(into: [[Character]: Int]()) { result, pair in
                result[[pair.0, pair.1], default: 0] += 1
            }

        for _ in 1 ... 40 {
            var newCounts: [[Character]: Int] = [:]
            for (pair, count) in pairsCount {
                let newLetter = rules[pair]!
                lettersCount[newLetter, default: 0] += count
                let left = [pair[0], newLetter]
                let right = [newLetter, pair[1]]
                newCounts[left, default: 0] += count
                newCounts[right, default: 0] += count
            }
            pairsCount = newCounts
        }

        let min = lettersCount.values.min(by: <)!
        let max = lettersCount.values.max(by: <)!
        let diff = max - min

        print("Part 2 (\(source)): \(diff)")
    }
}

InputData.allCases.forEach(Part2.run)
