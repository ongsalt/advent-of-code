import Foundation

// let inputFile = String()

func getInput() -> ([ClosedRange<Int>], [Int]) {

  let input = try! String(contentsOf: URL(filePath: "../input.txt", ), encoding: .utf8)

  let splitted: [String.SubSequence] = input.split(separator: "\n\n")

  let ranges: [ClosedRange<Int>] = splitted[0].split(separator: "\n").map { it in
    let s = it.split(separator: "-")

    assert(s.count == 2)

    return Int(s[0])!...Int(s[1])!
  }

  let testcases = splitted[1].split(separator: "\n").map { Int($0)! }

  return (ranges, testcases)
}

let (ranges, testcases) = getInput()

// // 1
// var count = 0

// for i in testcases {
//   if ranges.contains { $0.contains(i) } {
//     count += 1
//   }
// }

// print(count)

// 2 incoorect
// let finalRange = ranges.reduce(0...Int.max) { acc, range in
//   if acc.overlaps(range) {
//     return acc.clamped(to: range)
//   } else {
//     return 0...0
//   }
// }

// print(finalRange)
// print(finalRange.count)

var mergedRange: [ClosedRange<Int>] = []

for range in ranges {
  let overlapped = mergedRange.filter { $0.overlaps(range) }
  mergedRange.removeAll { overlapped.contains($0) }

  let merged = overlapped.reduce(range) { acc, r in
    min(acc.lowerBound, r.lowerBound)...max(acc.upperBound, r.upperBound)
  }
  mergedRange.append(merged)
}

let total = mergedRange.reduce(0) { acc, range in acc + range.count}
print(total)