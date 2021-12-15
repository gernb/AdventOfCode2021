//
//  main.swift
//  Day 15
//
//  Copyright © 2021 peter bohac. All rights reserved.
//

// MARK: - Part 1

print("Day 15:")

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    var neighbours: [Self] { [up, left, right, down] }
}

extension InputData {
    func asMap() -> [Coordinate: Int] {
        var map: [Coordinate: Int] = [:]
        for y in 0 ..< self.data.count {
            let line = Array(self.data[y])
            for x in 0 ..< line.count {
                let p = Coordinate(x: x, y: y)
                map[p] = Int(String(line[x]))
            }
        }
        return map
    }
}

enum Part1 {
    static func AStarFindShortestPath<Node: Hashable>(from start: Node, to target: Node, using getNextNodes: ((Node) -> [(node: Node, cost: Int)])) -> [Node] {
        typealias Path = [Node]
        var visited: [Node: (path: Path, cost: Int)] = [:]
        var queue: [Node: (path: Path, cost: Int)] = [start: ([], 0)]

        while let (node, (path, currentCost)) = queue.min(by: { $0.value.cost < $1.value.cost}) {
            queue.removeValue(forKey: node)
            if node == target {
                return path + [node]
            }
            let nextNodes = getNextNodes(node)
            let newPath = path + [node]
            nextNodes.forEach { nextNode, cost in
                let newCost = currentCost + cost
                if let previousPath = visited[nextNode], previousPath.cost <= newCost {
                    return
                }
                if let queued = queue[nextNode], queued.cost <= newCost {
                    return
                }
                queue[nextNode] = (newPath, newCost)
            }
            visited[node] = (path, currentCost)
        }

        preconditionFailure("No path to target!")
    }

    static func run(_ source: InputData) {
        let map = source.asMap()
        let maxX = map.keys.map(\.x).max()!
        let maxY = map.keys.map(\.y).max()!

        let shortestPath = AStarFindShortestPath(from: .origin, to: Coordinate(x: maxX, y: maxY)) { coord in
            coord.neighbours.compactMap {
                guard let risk = map[$0] else { return nil }
                return ($0, risk)
            }
        }
        let totalRisk = shortestPath.dropFirst().map { map[$0]! }.reduce(0, +)

        print("Part 1 (\(source)): \(totalRisk)")
    }
}

InputData.allCases.forEach(Part1.run)

// MARK: - Part 2

print("")

enum Part2 {
    static func run(_ source: InputData) {
        var map = source.asMap()

        var maxX = map.keys.map(\.x).max()! + 1
        var maxY = map.keys.map(\.y).max()! + 1
        for (coord, risk) in map {
            for y in 0 ..< 5 {
                for x in 0 ..< 5 {
                    if x == 0 && y == 0 { continue }
                    let newCoord = Coordinate(x: coord.x + maxX * x, y: coord.y + maxY * y)
                    var newRisk = risk + x + y
                    newRisk = newRisk > 9 ? newRisk % 10 + 1 : newRisk
                    map[newCoord] = newRisk
                }
            }
        }
        maxX = map.keys.map(\.x).max()!
        maxY = map.keys.map(\.y).max()!

        let shortestPath = Part1.AStarFindShortestPath(from: .origin, to: Coordinate(x: maxX, y: maxY)) { coord in
            coord.neighbours.compactMap {
                guard let risk = map[$0] else { return nil }
                return ($0, risk)
            }
        }
        let totalRisk = shortestPath.dropFirst().map { map[$0]! }.reduce(0, +)

        print("Part 2 (\(source)): \(totalRisk)")
    }
}

InputData.allCases.forEach(Part2.run)
