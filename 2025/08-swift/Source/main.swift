import Collections
import Foundation

struct Point: Equatable {
  let x: Double
  let y: Double
  let z: Double

  init?(fromString s: String) {
    let p = s.split(separator: ",").map { Double($0) }
    // No collect, fuck this
    if p.contains(nil) || p.count != 3 {
      return nil
    }

    self.x = p[0]!
    self.y = p[1]!
    self.z = p[2]!
  }

  func distance(to other: Point) -> Double {
    let dx = x - other.x
    let dy = y - other.y
    let dz = z - other.z
    return (dx * dx + dy * dy + dz * dz).squareRoot()
  }
}

struct Distance: Comparable {
  let from: Int
  let to: Int
  let distance: Double

  static func < (lhs: Distance, rhs: Distance) -> Bool {
    return lhs.distance < rhs.distance
  }
}

// wtf is this `try!/?` garbage
// why is there a result type but i cant use it in constructor
guard let input = try? String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8) else {
  fatalError("Input file not found")
}

let p = input.split(separator: "\n").map { Point(fromString: String($0)) }
if p.contains(nil) {
  fatalError("Invalid input")
}

let points = p.compactMap { $0 }
// use 2x as much memory as actually need, but who care
// var distances = Array(repeating: Array(repeating: 0.0, count: points.count), count: points.count)
var distances = Heap<Distance>()

for i in 0..<points.count {
  for j in i + 1..<points.count {
    let d = points[i].distance(to: points[j])
    distances.insert(Distance(from: i, to: j, distance: d))
  }
}

func part1(distances: Heap<Distance>) {
  var distances = distances
  var groupRoot: [Int] = Array(0..<points.count)

  for _ in 0..<1000 {
    guard let d = distances.popMin() else {
      break
    }

    let group = groupRoot[d.from]

    let otherGroupRoot = groupRoot[d.to]
    // might connect 2 group
    // replace latter group's root with first root
    // O(n) but fuck it
    groupRoot = groupRoot.map { $0 == otherGroupRoot ? group : $0 }

  }

  print(groupRoot)
  print(Set(groupRoot).count)

  let counts = Dictionary(grouping: groupRoot, by: { $0 })
    .mapValues { $0.count }

  print(counts)

  var s = Heap(counts.values)
  let n = [s.popMax()!, s.popMax()!, s.popMax()!]
  print(n)
  print(n.reduce(1, *))
}

func part2(distances: Heap<Distance>, points: [Point]) {
  var distances = distances
  var groupRoot: [Int] = Array(0..<points.count)
  var lastOne: Distance?

  while Set(groupRoot).count != 1 {  // bruh
    guard let d = distances.popMin() else {
      break
    }
    lastOne = d

    let group = groupRoot[d.from]

    let otherGroupRoot = groupRoot[d.to]
    // might connect 2 group
    // replace latter group's root with first root
    // O(n) but fuck it
    groupRoot = groupRoot.map { $0 == otherGroupRoot ? group : $0 }
  }

  let p1 = points[lastOne!.from]
  let p2 = points[lastOne!.to]

  print(p1.x * p2.x)
}

part2(distances: distances, points: points)
