//
//  main.swift
//  Day 02
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

enum Command {
    case forward(Int)
    case down(Int)
    case up(Int)

    init?(rawValue: String) {
        let tokens = rawValue.split(separator: " ")
        guard let value = Int(tokens[1]) else { return nil }
        switch tokens[0] {
        case "forward": self = .forward(value)
        case "down": self = .down(value)
        case "up": self = .up(value)
        default: return nil
        }
    }

    func execute(horizontal: inout Int, depth: inout Int) {
        switch self {
        case .forward(let value): horizontal += value
        case .down(let value): depth += value
        case .up(let value): depth -= value
        }
    }
}

// MARK: - Part 1

print("Day 02:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data.compactMap(Command.init)

        let (horizontal, depth) = input.reduce(into: (0, 0)) { result, command in
            command.execute(horizontal: &result.0, depth: &result.1)
        }
        let answer = horizontal * depth

        print("Part 1 (\(source)): Horizontal=\(horizontal), Depth=\(depth), Answer=\(answer)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Command {
    func execute2(horizontal: inout Int, depth: inout Int, aim: inout Int) {
        switch self {
        case .forward(let value):
            horizontal += value
            depth += aim * value
        case .down(let value): aim += value
        case .up(let value): aim -= value
        }
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data.compactMap(Command.init)

        let (horizontal, depth, aim) = input.reduce(into: (0, 0, 0)) { result, command in
            command.execute2(horizontal: &result.0, depth: &result.1, aim: &result.2)
        }
        let answer = horizontal * depth

        print("Part 2 (\(source)): Horizontal=\(horizontal), Depth=\(depth), Aim=\(aim), Answer=\(answer)")
    }
}

InputData.allCases.forEach(Part2.run)
