//
//  main.swift
//  Day 18
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 18:")

enum Number {
    case literal(Int)
    case pair(Pair)

    var value: Int {
        if case .literal(let v) = self { return v }
        fatalError()
    }
}

final class Pair {
    var left: Number
    var right: Number

    init(left: Number, right: Number) {
        self.left = left
        self.right = right
    }

    init(left: Pair, right: Pair) {
        self.left = .pair(left)
        self.right = .pair(right)
    }

    convenience init(_ rawValue: String) {
        var rawValue = ArraySlice(rawValue).dropFirst()
        self.init(&rawValue)
    }

    init(_ rawValue: inout ArraySlice<Character>) {
        var first = rawValue.removeFirst()
        if let v = Int(String(first)) {
            left = .literal(v)
        } else {
            assert(first == "[")
            left = .pair(Pair(&rawValue))
        }
        assert(rawValue.removeFirst() == ",")
        first = rawValue.removeFirst()
        if let v = Int(String(first)) {
            right = .literal(v)
        } else {
            assert(first == "[")
            right = .pair(Pair(&rawValue))
        }
        assert(rawValue.removeFirst() == "]")
    }
}

extension Pair: CustomStringConvertible {
    var description: String {
        var result = "["
        switch left {
        case .literal(let v): result += "\(v)"
        case .pair(let p): result += "\(p)"
        }
        result += ","
        switch right {
        case .literal(let v): result += "\(v)"
        case .pair(let p): result += "\(p)"
        }
        result += "]"
        return result
    }
}

extension Pair {
    static func + (lhs: Pair, rhs: Pair) -> Pair {
        let result = Pair(left: lhs, right: rhs)
        result.reduce()
        return result
    }

    func reduce() {
        var prev: (pair: Pair, value: Int, isLeft: Bool)?
        var next: Int?
        var actionPerformed = false

        func explode(pair: Pair, depth: Int) {
            if actionPerformed { return }
            switch pair.left {
            case .literal(let v):
                if let n = next {
                    pair.left = .literal(v + n)
                    next = nil
                    actionPerformed = true
                    return
                } else {
                    prev = (pair, v, true)
                }
            case .pair(let p):
                if depth == 4 {
//                    print("explode: \(p)")
                    if let prev = prev {
                        if prev.isLeft {
                            prev.pair.left = .literal(prev.value + p.left.value)
                        } else {
                            prev.pair.right = .literal(prev.value + p.left.value)
                        }
                    }
                    pair.left = .literal(0)
                    next = p.right.value
                } else {
                    explode(pair: p, depth: depth + 1)
                }
            }

            if actionPerformed { return }
            switch pair.right {
            case .literal(let v):
                if let n = next {
                    pair.right = .literal(v + n)
                    next = nil
                    actionPerformed = true
                    return
                } else {
                    prev = (pair, v, false)
                }
            case .pair(let p):
                if next != nil {
                    explode(pair: p, depth: depth)
                    return
                }
                if depth == 4 {
//                    print("explode: \(p)")
                    if let prev = prev {
                        if prev.isLeft {
                            prev.pair.left = .literal(prev.value + p.left.value)
                        } else {
                            prev.pair.right = .literal(prev.value + p.left.value)
                        }
                    }
                    pair.right = .literal(0)
                    next = p.right.value
                } else {
                    explode(pair: p, depth: depth + 1)
                }
            }
        }

        func split(pair: Pair) {
            if actionPerformed { return }
            switch pair.left {
            case .literal(let v):
                prev = (pair, v, true)
                if v >= 10 {
//                    print("split: \(v)")
                    pair.left = .pair(.init(left: .literal(v / 2), right: .literal(v - v / 2)))
                    actionPerformed = true
                    return
                }
            case .pair(let p):
                split(pair: p)
            }

            if actionPerformed { return }
            switch pair.right {
            case .literal(let v):
                prev = (pair, v, false)
                if v >= 10 {
//                    print("split: \(v)")
                    pair.right = .pair(.init(left: .literal(v / 2), right: .literal(v - v / 2)))
                    actionPerformed = true
                    return
                }
            case .pair(let p):
                split(pair: p)
            }
        }

        var before = ""
        var after = ""
        repeat {
            repeat {
                before = self.description
                prev = nil
                next = nil
                actionPerformed = false
                explode(pair: self, depth: 1)
                after = self.description
            } while before != after

            before = self.description
            prev = nil
            next = nil
            actionPerformed = false
            split(pair: self)
            after = self.description
        } while before != after

    }

    var magnitude: Int {
        let leftValue: Int
        switch left {
        case .literal(let v): leftValue = v
        case .pair(let p): leftValue = p.magnitude
        }
        let rightValue: Int
        switch right {
        case .literal(let v): rightValue = v
        case .pair(let p): rightValue = p.magnitude
        }
        return 3 * leftValue + 2 * rightValue
    }
}

var samplePair = Pair("[[9,1],[1,9]]")
let mag = samplePair.magnitude

//samplePair = Pair("[[[[[9,8],1],2],3],4]")
//samplePair = Pair("[7,[6,[5,[4,[3,2]]]]]")
//samplePair = Pair("[[6,[5,[4,[3,2]]]],1]")
//samplePair = Pair("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
//samplePair = Pair("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
//samplePair.reduce()

//let lhs = Pair("[[[[4,3],4],4],[7,[[8,4],9]]]")
//let rhs = Pair("[1,1]")
//let sum = lhs + rhs

//let sum = [Pair("[2,2]"), Pair("[3,3]"), Pair("[4,4]"), Pair("[5,5]"), Pair("[6,6]")].reduce(Pair("[1,1]"), +)
//print("")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.map(Pair.init)
        let sum = input.dropFirst().reduce(input.first!, +)
        let magnitude = sum.magnitude
        print("Part 1 (\(source)): \(magnitude)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Collection {
    func combinations(of size: Int) -> [[Element]] {
        func pick(_ count: Int, from: ArraySlice<Element>) -> [[Element]] {
            guard count > 0 else { return [] }
            guard count < from.count else { return [Array(from)] }
            if count == 1 {
                return from.map { [$0] }
            } else {
                return from.dropLast(count - 1)
                    .enumerated()
                    .flatMap { pair in
                        return pick(count - 1, from: from.dropFirst(pair.offset + 1)).map { [pair.element] + $0 }
                    }
            }
        }

        return pick(size, from: ArraySlice(self))
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data
        var sums: [String: Int] = [:]
        for combo in input.combinations(of: 2) {
            var lhs = Pair(combo[0])
            var rhs = Pair(combo[1])
            sums["\(lhs)+\(rhs)"] = (lhs + rhs).magnitude
            lhs = Pair(combo[1])
            rhs = Pair(combo[0])
            sums["\(lhs)+\(rhs)"] = (lhs + rhs).magnitude
        }
        let max = sums.values.max()!
        print("Part 2 (\(source)): \(max)")
    }
}

InputData.allCases.forEach(Part2.run)
