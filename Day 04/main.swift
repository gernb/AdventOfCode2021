//
//  main.swift
//  Day 04
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

final class BingoBoard {
    enum Square {
        case unmarked(Int)
        case marked(Int)

        var isMarked: Bool {
            if case .marked = self {
                return true
            }
            return false
        }
    }

    var board: [[Square]]

    init(_ input: [String]) {
        self.board = input.map { line in
            line.split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
                .map { Square.unmarked($0) }
        }
    }

    func unmarkedSum() -> Int {
        var sum = 0
        for row in board {
            for column in row {
                if case .unmarked(let value) = column {
                    sum += value
                }
            }
        }
        return sum
    }

    func mark(number: Int) -> Bool {
        for row in 0 ..< board.count {
            for column in 0 ..< board[row].count {
                if case .unmarked(let value) = board[row][column], value == number {
                    board[row][column] = .marked(value)
                    return checkWin()
                }
            }
        }
        return false
    }

    private func checkWin() -> Bool {
        // check rows
        for row in board {
            if row.filter(\.isMarked).count == 5 {
                return true
            }
        }
        // check columns
        for column in 0 ..< 5 {
            if board[0][column].isMarked && board[1][column].isMarked && board[2][column].isMarked && board[3][column].isMarked && board[4][column].isMarked {
                return true
            }
        }
        return false
    }
}

// MARK: - Part 1

print("Day 04:")

enum Part1 {
    static func run(_ source: InputData) {
        let input = source.data
        let numbers = input.first!
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
        let boards = input
            .dropFirst(2)
            .split(separator: "")
            .map(Array.init)
            .map(BingoBoard.init)

        func callNumbers() -> (sum: Int, finalNumber: Int) {
            for number in numbers {
                for board in boards {
                    if board.mark(number: number) {
                        return (board.unmarkedSum(), number)
                    }
                }
            }
            fatalError()
        }

        let (sum, number) = callNumbers()
        print("Part 1 (\(source)): sum = \(sum), number = \(number), answer = \(sum * number)")
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
