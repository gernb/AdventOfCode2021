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
    static var board = [10, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    static func run(player1Start: Int, player2Start: Int) {
        var cache: [String: (Int, Int)] = [:]

        func turn(position: (p1: Int, p2: Int), score: (p1: Int, p2: Int), player1Turn: Bool) -> (p1: Int, p2: Int) {
            if score.p1 >= 21 {
                return (1, 0)
            }
            if score.p2 >= 21 {
                return (0, 1)
            }

            let key = "\(position),\(score),\(player1Turn)"
            if let cached = cache[key] {
                return cached
            }

            var wins: (p1: Int, p2: Int) = (0, 0)
            for roll1 in 1...3 {
                for roll2 in 1...3 {
                    for roll3 in 1...3 {
                        let sum = [roll1, roll2, roll3].reduce(0, +)
                        let newPosition: (p1: Int, p2: Int)
                        var newScore = score
                        if player1Turn {
                            newPosition = ((position.p1 + sum) % 10, position.p2)
                            newScore.p1 += Self.board[newPosition.p1]
                        } else {
                            newPosition = (position.p1, (position.p2 + sum) % 10)
                            newScore.p2 += Self.board[newPosition.p2]
                        }
                        let newWins = turn(position: newPosition, score: newScore, player1Turn: !player1Turn)
                        wins.p1 += newWins.p1
                        wins.p2 += newWins.p2
                    }
                }
            }
            cache[key] = wins
            return wins
        }

        let wins = turn(position: (player1Start, player2Start), score: (0, 0), player1Turn: true)

        print("Part 2 start from \(player1Start), \(player2Start): player 1 wins: \(wins.p1), player 2 wins: \(wins.p2), max: \(max(wins.p1, wins.p2))")
    }
}

Part2.run(player1Start: 4, player2Start: 8)
Part2.run(player1Start: 6, player2Start: 7)
