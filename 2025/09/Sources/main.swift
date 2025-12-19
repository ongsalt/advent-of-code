import Foundation

struct Tile: Hashable {
    var x: Int
    var y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    init?(fromString s: String) {
        let p = s.split(separator: ",").map { Int($0) }
        // No collect, fuck this
        if p.contains(nil) || p.count != 2 {
            return nil
        }

        self.x = p[0]!
        self.y = p[1]!
    }
}

@MainActor
func getArea(_ candidate: Candidate) -> Int {
    let dx = abs(xmap[candidate.from.x]! - xmap[candidate.to.x]!) + 1
    let dy = abs(ymap[candidate.from.y]! - ymap[candidate.to.y]!) + 1

    return dx * dy
}

guard let input = try? String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8) else {
    fatalError("Input file not found")
}

let t = input.split(separator: "\n").map { Tile(fromString: String($0)) }
if t.contains(nil) {
    fatalError("Invalid input")
}

let tilessss: [Tile] = t.compactMap { $0 }

// compressed -> normal
var xmap: [Int: Int] = [:]
var ymap: [Int: Int] = [:]
// normal -> compressed
var xmap2: [Int: Int] = [:]
var ymap2: [Int: Int] = [:]

for (offset, x) in Set(tilessss.map { $0.x }).sorted().enumerated() {
    xmap[offset] = x
    xmap2[x] = offset
}

for (offset, y) in Set(tilessss.map { $0.y }).sorted().enumerated() {
    ymap[offset] = y
    ymap2[y] = offset
}

// print(xmap2)
let tiles = tilessss.map {
    return Tile(xmap2[$0.x]!, ymap2[$0.y]!)
}

// just stupid brute force
var maxSize = 0
var maxSizePair = (0, 0)

// compacted
let minX = tiles.map { $0.x }.min()! - 1
let maxX = tiles.map { $0.x }.max()! + 1
let minY = tiles.map { $0.y }.min()! - 1
let maxY = tiles.map { $0.y }.max()! + 1

// bruh, almost 100k * 100k
print(minX, minY, maxX, maxY)

var space: [Tile: Bool] = [tiles[0]: true]

for i in 0..<tiles.count - 1 {
    let to = tiles[i + 1]

    space[to] = true
    var x1 = tiles[i].x
    var x2 = tiles[i + 1].x
    var y1 = tiles[i].y
    var y2 = tiles[i + 1].y
    if x1 > x2 {
        swap(&x1, &x2)
    }
    if y1 > y2 {
        swap(&y1, &y2)
    }

    if x1 == x2 {
        for y in y1 + 1..<y2 {
            space[Tile(x1, y)] = true
        }
    } else if y1 == y2 {
        for x in x1 + 1..<x2 {
            space[Tile(x, y1)] = true
        }
    } else {
        fatalError("invalid input")
    }
}

var edges = space

// if a tile is inside, a ray from it to where........, min Y
// must cross the edge an odd number of times
@MainActor
func isIn(x: Int, y: Int) -> Bool {
    if let existing: Bool = space[Tile(x, y)] {
        // print(" > has edge")
        return existing
    }

    // print("isin \((x, y))")
    let dx1 = x - minX
    let dx2 = maxX - x
    let dy1 = y - minY
    let dy2 = maxY - x
    let selected = min(dx1, dx2, dy1, dy2)

    var crossed = 0
    var isInEdge = false

    switch selected {
    case dx1:
        // print("Case 1")
        for i in minX...x {
            if isInEdge && edges[Tile(i, y)] == nil {
                isInEdge = false
                crossed += 1
            }

            // print("\((i,y)) \(edges[Tile(i, y)])")
            isInEdge = edges[Tile(i, y)] != nil
        }
    case dx2:
        // print("Case 2")
        for i in x...maxX {
            // print("\((i,y)) : \(edges[Tile(i, y)])")

            if isInEdge && edges[Tile(i, y)] == nil {
                isInEdge = false
                crossed += 1
            }

            isInEdge = edges[Tile(i, y)] != nil
        }
    case dy1:
        // print("Case 3")
        for i in minY...y {
            if isInEdge && edges[Tile(x, i)] == nil {
                isInEdge = false
                crossed += 1
            }

            isInEdge = edges[Tile(x, i)] != nil
        }
    case dy2:
        // print("Case 4")
        for i in y...maxY {
            if isInEdge && edges[Tile(x, i)] == nil {
                isInEdge = false
                crossed += 1
            }

            isInEdge = edges[Tile(x, i)] != nil
        }
    default:
        crossed = 0
    }

    // if isInEdge {
    //     crossed += 1
    // }

    let ok = crossed % 2 == 1

    // if !ok {
    // print(" > crossed \(crossed)")
    // }

    space[Tile(x, y)] = ok

    return ok
}

struct Candidate {
    let from: Tile
    let to: Tile

    init(_ from: Tile, _ to: Tile) {
        self.from = from
        self.to = to
    }
}

var candidates: [Candidate] = []

// another assumption: this must have no hole (which is, from the input format, probably not)
// we can just trace along the edge to check if it valid area or not
for i in 0..<tiles.count {
    for j in i + 1..<tiles.count {
        candidates.append(Candidate(tiles[i], tiles[j]))
    }
}

candidates.sort { getArea($1) < getArea($0) }

// candidates = candidates.filter { getArea($0) == 24 }

// candidates = [candidates.first { $0.area == 24 }!]
// print(candidates[0])

var round = 0

// check if its usable
for candidate in candidates {
    round += 1
    if round % 1000 == 0 {
        print("[round] \(round)")
    }
    var x1 = candidate.from.x
    var x2 = candidate.to.x
    var y1 = candidate.from.y
    var y2 = candidate.to.y
    if x1 > x2 {
        swap(&x1, &x2)
    }
    if y1 > y2 {
        swap(&y1, &y2)
    }


    // scan 4 corner
    if !(isIn(x: x1, y: y1) && isIn(x: x2, y: y1) && isIn(x: x1, y: y2)
        && isIn(x: x2, y: y2)  // && isIn(x: (x1 + x2) / 2, y: (y1 + y2) / 2)
        )
    {
        // && isIn(x: x1, y: (y1 + y2) / 2)
        // && isIn(x: x2, y: (y1 + y2) / 2)
        // && isIn(x: (x1 + x2) / 2, y: y1)
        // && isIn(x: (x1 + x2) / 2, y: y1)
        continue
    }

    print("\((candidate)) [\(getArea(candidate))]")


    // print(" - pass")

    // scan 4 edge
    // shuold i just memoized this
    let ok =
        (x1...x2).allSatisfy {
            isIn(x: $0, y: y1) && isIn(x: $0, y: y2)
        }
        && (y1...y2).allSatisfy {
            isIn(x: x1, y: $0) && isIn(x: x2, y: $0)
        }

    if ok {
        print(" - from (\((xmap[x1]!, ymap[y1]!))) to (\((xmap[x2]!, ymap[y2]!)))")
        print(" - Ok \(getArea(candidate))")
        // first hit
        break
    }
}
// print(maxSizePair)
