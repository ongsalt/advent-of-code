import Foundation

struct Input {
  let start: Node
  // Node(Position) by lines
  let splitters: [Int: [Node]]
  let width: Int
  let height: Int
}

struct Node {
  let id: Int
  let x: Int
  let y: Int
}

extension Array {
  mutating func popFirst() -> Element? {
    return isEmpty ? nil : removeFirst()
  }
}

func parse(path: String) -> Input {
  guard let input = try? String(contentsOf: URL(filePath: path), encoding: .utf8) else {
    fatalError("Input file not found (\(path))")
  }

  var id = 1
  let lines = input.split(separator: "\n")
  var start = Node(id: 0, x: 0, y: 0)
  var splitters: [Int: [Node]] = [:]

  for (y, line) in lines.enumerated() {
    var s: [Node] = []
    for (x, c) in line.enumerated() {
      if c == "^" {
        s.append(Node(id: id, x: x, y: y))
        id += 1
      } else if c == "S" {
        start = Node(id: 0, x: x, y: y)
      }
    }

    if !s.isEmpty {
      splitters[y] = s
    }
  }

  return Input(start: start, splitters: splitters, width: lines[0].count, height: lines.count)
}

func partOne(input: Input) {
  var beams = Set<Int>([input.start.x])
  var splitCounts = 0

  let layers = input.splitters.keys.filter({ $0 > input.start.y }).sorted()

  for y in layers {
    var newBeams = beams
    let splitters = input.splitters[y]!

    // fuck this, set doesnt gaurantee any sorting
    for beam in beams.sorted() {
      if splitters.contains(where: { $0.x == beam }) {
        splitCounts += 1
        if beam + 1 < input.width {
          newBeams.insert(beam + 1)
        }
        if beam > 0 {
          newBeams.insert(beam - 1)
        }
      }
    }

    beams = newBeams.filter { beam in !splitters.contains { $0.x == beam } }
  }

  // print(input)
  // print(beams)
  print(splitCounts)
}

func buildGraph(input: Input) -> [[Bool]] {
  let nodeCount = input.splitters.values.map { $0.count }.reduce(1, +)
  var graph = Array(repeating: Array(repeating: false, count: nodeCount), count: nodeCount)

  // [x: fromNodeId]
  var beams = [input.start.x: input.start.id]
  var splitCounts = 0

  let layers = input.splitters.keys.filter({ $0 > input.start.y }).sorted()

  var nodes: [Int: Node] = [:]
  nodes[0] = input.start

  for list in input.splitters.values {
    for node in list {
      nodes[node.id] = node
    }
  }

  for y in layers {
    var newBeams = beams
    let splitters = input.splitters[y]!

    // swift set is not sorteddddddddddddd
    let sortedBeam = beams.map { ($0, $1) }.sorted { a, b in a.0 < b.0 }

    for (beam, fromNodeId) in sortedBeam {
      if let node = splitters.first(where: { $0.x == beam }) {
        splitCounts += 1
        graph[fromNodeId][node.id] = true
        let n1 = nodes[fromNodeId]!
        if let n2 = nodes[fromNodeId - 1] {
          if n1.y == n2.y && n2.x + 2 == n1.x && n2.x == node.x - 1 {
            print("current \(node), n1: \(n1), n2: \(n2)")
            graph[n2.id][node.id] = true
          }
        }
        if beam + 1 < input.width {
          newBeams[beam + 1] = node.id
        }
        if beam > 0 {
          newBeams[beam - 1] = node.id
        }
      }
    }

    beams = newBeams.filter { beam, fromNodeId in !splitters.contains { $0.x == beam } }
  }

  return graph
}

func printAdjacencyMatrix(_ matrix: [[Bool]]) {
  for row in matrix {
    for (x, cell) in row.enumerated() {
      print(cell ? x : "_", terminator: " ")
    }
    print()
  }
}

func partTwo(input: Input) {
  let graph = buildGraph(input: input)
  printAdjacencyMatrix(graph)

  var pathCount = Array(repeating: 0, count: graph.count)
  pathCount[0] = 1
  var visited = Array(repeating: false, count: graph.count)

  // from node0
  var nexts = [0]
  while let current = nexts.popFirst() {
    if visited[current] {
      continue
    }
    visited[current] = true

    for i in 0..<graph.count {
      if graph[i][current] {
        pathCount[current] += pathCount[i]
      }
    }

    print("Visit \(current) : \(pathCount[current])")

    for i in 0..<graph.count {
      if graph[current][i] {
        nexts.append(i)
      }
    }
  }

  print(pathCount)
}

func partTwoFrFr(input: Input) {

  // [beamCol, count]
  var beams = [input.start.x: 1]
  var splitCounts = 0

  let layers = input.splitters.keys.filter({ $0 > input.start.y }).sorted()

  for y in layers {
    var newBeams = beams
    let splitters = input.splitters[y]!

    for (beamCol, count) in beams {
      if splitters.contains(where: { $0.x == beamCol }) {
        splitCounts += 1
        if beamCol + 1 < input.width {
          newBeams[beamCol + 1] = (newBeams[beamCol + 1] ?? 0) + count
        }
        if beamCol > 0 {
          newBeams[beamCol - 1] = (newBeams[beamCol - 1] ?? 0) + count
        }
      }
    }

    beams = newBeams.filter { beam in !splitters.contains { $0.x == beam.0 } }
  }

  // print(splitCounts)
  print(beams.values.reduce(0, +))
}

let input = parse(path: "./input.txt")

// partOne(input: input)

// part one is now just graph.edgeCount
// let graph = buildGraph(input: input)
// print(graph.map { $0.count { $0 == true } }.reduce(0, +))

partTwoFrFr(input: input)
