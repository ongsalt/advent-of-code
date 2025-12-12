import Foundation

// fuck this
extension String {
  subscript(i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }

  func toIndex(_ i: Int) -> Index {
    return index(startIndex, offsetBy: i)
  }
}

let input = try! String(contentsOf: URL(filePath: "./input.txt"), encoding: .utf8)
var lines = input.split(separator: "\n").map { String($0) }

let opLine = lines.popLast()!

let whitespace: Character = " "
var columnOffsets = opLine.indices.filter { opLine[$0] != whitespace }.map {
  $0.utf16Offset(in: opLine)
}
columnOffsets.append(opLine.indices.last!.utf16Offset(in: opLine) + 2)

var columns: [[String]] = Array(repeating: [], count: columnOffsets.count - 1)

for line in lines {
  for i in 0..<(columnOffsets.count - 1) {
    let start = line.toIndex(columnOffsets[i])
    let end = line.toIndex(columnOffsets[i + 1] - 1)  // inclusive

    columns[i].append(String(line[start..<end]))
  }
}

let bsColumns = columns.map { column in
  let w = column[0].count
  var numbers: [Int] = []

  for i in 0..<w {
    var num: String = ""
    for n in column {
      let c = n[i]
      if c != whitespace {
        num += String(c)
      }
    }

    numbers.append(Int(num)!)
  }

  return numbers
}

// print(columns)

let ops = opLine.split(separator: " ").map { Ops(rawValue: String($0))! }

let values = zip(bsColumns, ops).map { (row, op) in
  row.reduce(op == .add ? 0 : 1) { acc, i in op.apply(acc: acc, other: i) }
}

// print(values)
print(values.reduce(0, +))
