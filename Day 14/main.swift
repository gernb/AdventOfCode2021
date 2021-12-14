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

        var pairsCount: [[Character]: Int] = [:]
        for pair in zip(template, template.dropFirst()) {
            pairsCount[[pair.0, pair.1], default: 0] += 1
        }

        for _ in 1 ... 40 {
            var newCounts: [[Character]: Int] = [:]
            for (pair, count) in pairsCount {
                let rule = rules[pair]!
                let left = [pair[0], rule]
                let right = [rule, pair[1]]
                newCounts[left, default: 0] += count
                newCounts[right, default: 0] += count
            }
            pairsCount = newCounts
        }

        var lettersCount: [Character: Int] = [:]
        for (pair, count) in pairsCount {
            lettersCount[pair[0], default: 0] += count
            lettersCount[pair[1], default: 0] += count
        }
        lettersCount[template.first!, default: 0] += 1
        lettersCount[template.last!, default: 0] += 1

        let min = lettersCount.min { lhs, rhs in
            lhs.value < rhs.value
        }!.value / 2
        let max = lettersCount.max { lhs, rhs in
            lhs.value < rhs.value
        }!.value / 2
        let diff = max - min

        print("Part 2 (\(source)): \(diff)")
    }
}

InputData.allCases.forEach(Part2.run)
