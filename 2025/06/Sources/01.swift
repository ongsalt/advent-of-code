import Foundation

enum Ops: String {
  case add = "+"
  case multiply = "*"

  func apply(acc: Int, other: Int) -> Int {
    switch self {
    case .add:
      return acc + other
    case .multiply:
      return acc * other
    }
  }
}

func asdguu() {

  let input = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
  var parsed = input.split(separator: "\n").map { $0.split(separator: " ") }

  let ops = parsed.popLast()!.map { Ops(rawValue: String($0))! }
  var values = ops.map { $0 == .add ? 0 : 1 }

  // 1

  let numbers = parsed.map { $0.map { Int($0)! } }
  for row: [Int] in numbers {
    for (i, n) in row.enumerated() {
      let op = ops[i]
      values[i] = op.apply(acc: values[i], other: n)
    }
  }

  let sum = values.reduce(0, +)

  print(sum)

}
