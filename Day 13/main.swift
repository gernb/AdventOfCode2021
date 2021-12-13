//
//  main.swift
//  Day 13
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 13:")

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    init(rawValue: String) {
        let values = rawValue.components(separatedBy: ",").compactMap(Int.init)
        self.x = values[0]
        self.y = values[1]
    }
}

struct Paper {
    let dots: Set<Point>

    var maxX: Int { dots.map(\.x).max()! }
    var maxY: Int { dots.map(\.y).max()! }

    func fold(_ fold: Fold) -> Paper {
        switch fold {
        case .vertical(let col):
            assert(maxX / 2 == col)
            var newDots: Set<Point> = []
            for p in dots {
                if p.x < col {
                    newDots.insert(p)
                } else {
                    newDots.insert(Point(x: col - (p.x - col), y: p.y))
                }
            }
            return Paper(dots: newDots)

        case .horizontal(let row):
            assert(maxY / 2 == row)
            var newDots: Set<Point> = []
            for p in dots {
                if p.y < row {
                    newDots.insert(p)
                } else {
                    newDots.insert(Point(x: p.x, y: row - (p.y - row)))
                }
            }
            return Paper(dots: newDots)
        }
    }
}

enum Fold {
    case vertical(Int) // X=...
    case horizontal(Int) // y=...
}

extension Fold {
    init(rawValue: String) {
        let tokens = rawValue.components(separatedBy: " ")
        let instruction = tokens[2].components(separatedBy: "=")
        if instruction[0] == "x" {
            self = .vertical(Int(instruction[1])!)
        } else {
            self = .horizontal(Int(instruction[1])!)
        }
    }
}

extension InputData {
    func loadPaperAndFolds() -> (Paper, [Fold]) {
        var dots: Set<Point> = []
        var line = 0
        while self.data[line] != "" {
            dots.insert(Point(rawValue: self.data[line]))
            line += 1
        }
        let folds = (line + 1 ..< self.data.count).map { Fold(rawValue: self.data[$0]) }
        return (Paper(dots: dots), folds)
    }
}

enum Part1 {
    static func run(_ source: InputData) {
        var (paper, folds) = source.loadPaperAndFolds()

        paper = paper.fold(folds[0])

        print("Part 1 (\(source)): \(paper.dots.count)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

extension Paper {
    func draw() {
        for y in 0 ... maxY {
            for x in 0 ... maxX {
                print(dots.contains(Point(x: x, y: y)) ? "█" : " ", terminator: "")
            }
            print("")
        }
        print("")
    }
}

enum Part2 {
    static func run(_ source: InputData) {
        var (paper, folds) = source.loadPaperAndFolds()

        for fold in folds {
            paper = paper.fold(fold)
        }

        print("Part 2 (\(source)): \(paper.dots.count)")
        paper.draw()
    }
}

InputData.allCases.forEach(Part2.run)
