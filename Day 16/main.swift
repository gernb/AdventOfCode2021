//
//  main.swift
//  Day 16
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 16:")

extension InputData {
    var nibbles: [Character] {
        Array(self.data[0])
    }
}

enum Part1 {
    enum ParseType {
        case version(Int)
        case type(Int)
        case literal(Int)
        case operatorLen(Int)
        case subPacketCount(Int)
    }

    static func parseVersion(_ rawValue: inout ArraySlice<Character>, bitOffset: inout Int) -> ParseType {
        switch bitOffset {
        case 0:
            let version = (Int(String(rawValue.first!), radix: 16)! >> 1) & 0b111
            bitOffset = 3
            return .version(version)

        case 1:
            let version = Int(String(rawValue.first!), radix: 16)! & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 0
            return .version(version)

        case 2:
            let version = (Int(String(rawValue.prefix(2)), radix: 16)! >> 3) & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 1
            return .version(version)

        case 3:
            let version = (Int(String(rawValue.prefix(2)), radix: 16)! >> 2) & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 2
            return .version(version)

        default:
            fatalError()
        }
    }

    static func parseType(_ rawValue: inout ArraySlice<Character>, bitOffset: inout Int) -> ParseType {
        switch bitOffset {
        case 0:
            let value = (Int(String(rawValue.first!), radix: 16)! >> 1) & 0b111
            bitOffset = 3
            return .type(value)

        case 1:
            let value = Int(String(rawValue.first!), radix: 16)! & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 0
            return .type(value)

        case 2:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 3) & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 1
            return .type(value)

        case 3:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 2) & 0b111
            rawValue = rawValue.dropFirst()
            bitOffset = 2
            return .type(value)

        default:
            fatalError()
        }
    }

    static func parseLiteral(_ rawValue: inout ArraySlice<Character>, bitOffset: inout Int) -> ParseType {
        switch bitOffset {
        case 0:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 3) & 0b11111
            rawValue = rawValue.dropFirst()
            bitOffset = 1
            return .literal(value)

        case 1:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 2) & 0b11111
            rawValue = rawValue.dropFirst()
            bitOffset = 2
            return .literal(value)

        case 2:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 1) & 0b11111
            rawValue = rawValue.dropFirst()
            bitOffset = 3
            return .literal(value)

        case 3:
            let value = (Int(String(rawValue.prefix(2)), radix: 16)! >> 0) & 0b11111
            rawValue = rawValue.dropFirst(2)
            bitOffset = 0
            return .literal(value)

        default:
            fatalError()
        }
    }

    static func parseOperatorLen(_ rawValue: inout ArraySlice<Character>, bitOffset: inout Int) -> ParseType {
        let lenType: Int
        switch bitOffset {
        case 0:
            lenType = (Int(String(rawValue.first!), radix: 16)! >> 3) & 0b1

        case 1:
            lenType = (Int(String(rawValue.first!), radix: 16)! >> 2) & 0b1

        case 2:
            lenType = (Int(String(rawValue.first!), radix: 16)! >> 1) & 0b1

        case 3:
            lenType = (Int(String(rawValue.first!), radix: 16)! >> 0) & 0b1

        default:
            fatalError()
        }

        if lenType == 0 {
            switch bitOffset {
            case 0:
                let value = (Int(String(rawValue.prefix(4)), radix: 16)! >> 0) & 0b111111111111111
                rawValue = rawValue.dropFirst(4)
                bitOffset = 0
                return .operatorLen(value)

            case 1:
                let value = (Int(String(rawValue.prefix(5)), radix: 16)! >> 3) & 0b111111111111111
                rawValue = rawValue.dropFirst(4)
                bitOffset = 1
                return .operatorLen(value)

            case 2:
                let value = (Int(String(rawValue.prefix(5)), radix: 16)! >> 2) & 0b111111111111111
                rawValue = rawValue.dropFirst(4)
                bitOffset = 2
                return .operatorLen(value)

            case 3:
                let value = (Int(String(rawValue.prefix(5)), radix: 16)! >> 1) & 0b111111111111111
                rawValue = rawValue.dropFirst(4)
                bitOffset = 3
                return .operatorLen(value)

            default:
                fatalError()
            }
        } else {
            switch bitOffset {
            case 0:
                let value = (Int(String(rawValue.prefix(3)), radix: 16)! >> 0) & 0b11111111111
                rawValue = rawValue.dropFirst(3)
                bitOffset = 0
                return .subPacketCount(value)

            case 1:
                let value = (Int(String(rawValue.prefix(4)), radix: 16)! >> 3) & 0b11111111111
                rawValue = rawValue.dropFirst(3)
                bitOffset = 1
                return .subPacketCount(value)

            case 2:
                let value = (Int(String(rawValue.prefix(4)), radix: 16)! >> 2) & 0b11111111111
                rawValue = rawValue.dropFirst(3)
                bitOffset = 2
                return .subPacketCount(value)

            case 3:
                let value = (Int(String(rawValue.prefix(4)), radix: 16)! >> 1) & 0b11111111111
                rawValue = rawValue.dropFirst(3)
                bitOffset = 3
                return .subPacketCount(value)

            default:
                fatalError()
            }
        }
    }

    static func parsePacket(_ rawValue: inout ArraySlice<Character>, bitOffset: inout Int, count: Int? = nil, len: Int? = nil) -> [ParseType] {
        if count == nil && len == nil {
            return []
        }
        if let count = count, count < 1 {
            return []
        }
        if let len = len, len == 0 {
            return []
        }

        let version = parseVersion(&rawValue, bitOffset: &bitOffset)
        let type = parseType(&rawValue, bitOffset: &bitOffset)
        var result = [version, type]
        switch type {

        case .type(4):
            var literal = parseLiteral(&rawValue, bitOffset: &bitOffset)
            result.append(literal)
            while case .literal(let val) = literal, val > 0xF {
                literal = parseLiteral(&rawValue, bitOffset: &bitOffset)
                result.append(literal)
            }

        case .type:
            let len = parseOperatorLen(&rawValue, bitOffset: &bitOffset)
            result.append(len)
            switch len {
            case .operatorLen(let value):
                result.append(contentsOf: parsePacket(&rawValue, bitOffset: &bitOffset, len: value))
            case .subPacketCount(let value):
                result.append(contentsOf: parsePacket(&rawValue, bitOffset: &bitOffset, count: value))
            default:
                fatalError()
            }

        default:
            fatalError()
        }

        if let count = count {
            return result + parsePacket(&rawValue, bitOffset: &bitOffset, count: count - 1)
        } else if let len = len {
            let parsedLen = result.map { t -> Int in
                switch t {
                case .version: return 3
                case .type: return 3
                case .literal: return 5
                case .operatorLen: return 16
                case .subPacketCount: return 12
                }
            }.reduce(0, +)
            return result + parsePacket(&rawValue, bitOffset: &bitOffset, len: len - parsedLen)
        }
        return result
    }

    static func run(_ source: InputData) {
        var nibbles = ArraySlice(source.nibbles)
        var offset = 0

        let parsed = parsePacket(&nibbles, bitOffset: &offset, count: 1)
        let versionSum = parsed.compactMap {
            if case .version(let v) = $0 {
                return v
            } else {
                return nil
            }
        }.reduce(0, +)

        print("Part 1 (\(source)): \(versionSum)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    enum Packet {
        case literal(version: Int, type: Int, value: Int)
        indirect case `operator`(version: Int, type: Int, subpackets: [Packet])

        func execute() -> Int {
            switch self {
            case .literal(_, _, let value):
                return value

            case .operator(_, 0, let subpackets):
                return subpackets.map { $0.execute() }.reduce(0, +)
            case .operator(_, 1, let subpackets):
                return subpackets.map { $0.execute() }.reduce(1, *)
            case .operator(_, 2, let subpackets):
                return subpackets.map { $0.execute() }.min()!
            case .operator(_, 3, let subpackets):
                return subpackets.map { $0.execute() }.max()!

            case .operator(_, 5, let subpackets):
                return subpackets[0].execute() > subpackets[1].execute() ? 1 : 0
            case .operator(_, 6, let subpackets):
                return subpackets[0].execute() < subpackets[1].execute() ? 1 : 0
            case .operator(_, 7, let subpackets):
                return subpackets[0].execute() == subpackets[1].execute() ? 1 : 0

            default:
                fatalError()
            }
        }
    }

    static func convert(_ parsed: inout ArraySlice<Part1.ParseType>) -> Packet {
        let version: Int
        let type: Int
        if case .version(let v) = parsed.first! {
            version = v
            parsed = parsed.dropFirst()
        } else {
            fatalError()
        }
        if case .type(let t) = parsed.first! {
            type = t
            parsed = parsed.dropFirst()
        } else {
            fatalError()
        }
        if type == 4 {
            var value = 0
            while case .literal(let val) = parsed.first! {
                value = value * 16 + (val & 0xF)
                parsed = parsed.dropFirst()
                if val <= 0xF {
                    break
                }
            }
            return .literal(version: version, type: type, value: value)
        } else {
            let lenType = parsed.first!
            parsed = parsed.dropFirst()
            switch lenType {
            case .subPacketCount(let count):
                var packets: [Packet] = []
                for _ in 1 ... count {
                    packets.append(convert(&parsed))
                }
                return .operator(version: version, type: type, subpackets: packets)

            case .operatorLen(let len):
                var idx = 0
                var count = 0
                repeat {
                    idx += 1
                    count = parsed.prefix(idx)
                        .map { t -> Int in
                            switch t {
                            case .version: return 3
                            case .type: return 3
                            case .literal: return 5
                            case .operatorLen: return 16
                            case .subPacketCount: return 12
                            }
                        }.reduce(0, +)
                } while count != len
                var newSlice = parsed.prefix(idx)
                parsed = parsed.dropFirst(idx)
                var packets: [Packet] = []
                var isNotEmpty = !newSlice.isEmpty
                while isNotEmpty {
                    packets.append(convert(&newSlice))
                    isNotEmpty = !newSlice.isEmpty
                }
                return .operator(version: version, type: type, subpackets: packets)

            default:
                fatalError()
            }
        }
    }

    static func run(_ source: [Character]) {
        var nibbles = ArraySlice(source)
        var offset = 0

        var parsed = ArraySlice(Part1.parsePacket(&nibbles, bitOffset: &offset, count: 1))
        let packet = convert(&parsed)
        let answer = packet.execute()

        print("Part 2: \(answer)")
    }
}

Part2.run(Array("C200B40A82"))
Part2.run(Array("9C0141080250320F1802104A08"))
Part2.run(InputData.challenge.nibbles)
