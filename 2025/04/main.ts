const raw = await Bun.file("./input.txt").text();

enum Tile {
  None,
  Roll,
  MarkedRoll,
}

function toTile(c: string): Tile {
  if (c === ".") {
    return Tile.None;
  } else {
    return Tile.Roll;
  }
}

const neighbourMap = [
  [1, 1],
  [1, 0],
  [1, -1],
  [0, 1],
  [0, -1],
  [-1, 1],
  [-1, 0],
  [-1, -1],
] as const;

const input = raw.split("\n").map((line) => [...line].map((c) => toTile(c)));
const repeat = true;

function neighbour(x: number, y: number) {
  let count = 0;
  for (const [dx, dy] of neighbourMap) {
    if (input[y + dy]?.[x + dx] == Tile.Roll) {
      count += 1;
    }
  }
  return count;
}

let total = 0;

while (true) {
  const neighbourCount = input.map((row, y) =>
    row.map((tile, x) => [tile, neighbour(x, y)] as [Tile, number])
  );

  // const text = neighbourCount
  //   .map((row) => row.map(([_, count]) => count).join(" "))
  //   .join("\n");
  // const text2 = neighbourCount
  //   .map((row) => row.map(([tile, c]) => (c < 4 ? "X" : tile)).join(" "))
  //   .join("\n");

  let count = 0;
  neighbourCount.forEach((row, y) => {
    row.forEach(([tile, c], x) => {
      if (tile === Tile.Roll && c < 4) {
        count += 1;
        input[y][x] = Tile.MarkedRoll;
      }
    });
  });

  // console.log(text);
  // console.log(text2);

  if (count === 0 || !repeat) {
    break;
  }
  total += count;
}

console.log(total);
