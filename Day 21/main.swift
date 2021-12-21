//
//  main.swift
//  Day 21
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 21:")

enum Part1 {
    static var dice = Array(1...100)
    static var board = [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    static func run(player1Start: Int, player2Start: Int) {
        var p1 = player1Start
        var p2 = player2Start
        var p1Score = 0
        var p2Score = 0
        var rollCount = -1

        while true {
            rollCount += 1
            var move = Self.dice[rollCount % 100]
            rollCount += 1
            move += Self.dice[rollCount % 100]
            rollCount += 1
            move += Self.dice[rollCount % 100]
            p1 += move
            p1Score += Self.board[p1 % 10]
            if p1Score >= 1000 {
                break
            }

            rollCount += 1
            move = Self.dice[rollCount % 100]
            rollCount += 1
            move += Self.dice[rollCount % 100]
            rollCount += 1
            move += Self.dice[rollCount % 100]
            p2 += move
            p2Score += Self.board[p2 % 10]
            if p2Score >= 1000 {
                break
            }
        }

        let answer = min(p1Score, p2Score) * (rollCount + 1)

        print("Part 1 start from \(player1Start), \(player2Start): losing score: \(min(p1Score, p2Score)), dice rolls: \(rollCount + 1), result: \(answer)")
    }
}

Part1.run(player1Start: 4, player2Start: 8)
Part1.run(player1Start: 6, player2Start: 7)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        let input = source.data

        print("Part 2 (\(source)):")
    }
}

InputData.allCases.forEach(Part2.run)
