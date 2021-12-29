//
//  main.swift
//  Day 24
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 24:")

enum Instruction {
    enum Source {
        case literal(Int)
        case register(String)

        func value(_ registers: [String: Int]) -> Int {
            switch self {
            case .literal(let v): return v
            case .register(let r): return registers[r, default: 0]
            }
        }
    }

    case inp(String)
    case add(String, Source)
    case mul(String, Source)
    case div(String, Source)
    case mod(String, Source)
    case eql(String, Source)
}

extension Instruction.Source {
    init(_ rawValue: String) {
        if let value = Int(rawValue) {
            self = .literal(value)
        } else {
            self = .register(rawValue)
        }
    }
}

extension Instruction {
    init(_ rawValue: String) {
        let tokens = rawValue.components(separatedBy: " ")
        switch tokens[0] {
        case "inp": self = .inp(tokens[1])
        case "add": self = .add(tokens[1], .init(tokens[2]))
        case "mul": self = .mul(tokens[1], .init(tokens[2]))
        case "div": self = .div(tokens[1], .init(tokens[2]))
        case "mod": self = .mod(tokens[1], .init(tokens[2]))
        case "eql": self = .eql(tokens[1], .init(tokens[2]))
        default: fatalError()
        }
    }
}

extension InputData {
    func asInstructions() -> [Instruction] {
        self.data.map(Instruction.init)
    }
}

final class Program {
    var registers: [String: Int] = [:]
    let instructions: [Instruction]

    init(_ instructions: [Instruction]) {
        self.instructions = instructions
    }

    func run(input: [Int]) -> Int {
        var input = input
        for instruction in instructions {
            switch instruction {
            case .inp(let dest):
                registers[dest] = input.removeFirst()
            case .add(let dest, let source):
                registers[dest, default: 0] += source.value(registers)
            case .mul(let dest, let source):
                let result = registers[dest, default: 0].multipliedReportingOverflow(by: source.value(registers))
                if result.overflow {
                    return Int.min
                }
                registers[dest] = result.partialValue
            case .div(let dest, let source):
                registers[dest, default: 0] /= source.value(registers)
            case .mod(let dest, let source):
                registers[dest, default: 0] %= source.value(registers)
            case .eql(let dest, let source):
                registers[dest] = registers[dest, default: 0] == source.value(registers) ? 1 : 0
            }
        }
        return registers["z"]!
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        let instructions = source.asInstructions()
        let p = Program(instructions)
        var largestModelNum = 0

        for modelNum in (11111111111111 ... 99999999999999).reversed() {
            let model = Array("\(modelNum)").map(String.init).compactMap(Int.init)
            if model.contains(0) {
                continue
            }
//            print(modelNum)
            if p.run(input: model) == 0 {
                largestModelNum = modelNum
                break
            }
        }

        print("Part 1 (\(source)): \(largestModelNum)")
    }
}

// Solved manually by reverse-engineering the input
//InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
