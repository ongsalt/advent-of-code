export type And<Lhs extends boolean, Rhs extends boolean> = Lhs extends true
    ? Rhs
    : false

export type Or<Lhs extends boolean, Rhs extends boolean> = Lhs extends false
    ? Rhs extends false
        ? false
        : true
    : true
 
// Math
export type CreateRange<N extends number, Temp extends number[] = []> = Temp["length"] extends N ? Temp : CreateRange<N, [0, ...Temp]>

export type Add<Lhs extends number, Rhs extends number> = [
    ...CreateRange<Lhs>,
    ...CreateRange<Rhs>
]["length"]

// export type Sum<Input extends number[]> = 
//     Input extends [infer It extends number, ...infer Rest extends number[]]
//         ? Add<It, Sum<Rest>>
//         : 0

export type IndexOf<T extends object> = keyof {
    [K in keyof T as K extends `${number}` ? K : never]: never
}

export type IsMoreThan<Lhs extends number, Rhs extends number> = 
    IndexOf<CreateRange<Lhs>> extends IndexOf<CreateRange<Rhs>> // Lhs <= Rhs
        ? false
        : true

type a = IsMoreThan<8, 4>

// Caller must gaurantee that lhs > rhs
export type _IsStepSafe<Lhs extends number[], Rhs extends number[], Accumulator extends number[] = []> = 
    Accumulator["length"] extends 4
        ? false
        : Lhs extends Rhs
            ? Accumulator["length"] extends 0
                ? false
                : true
            : _IsStepSafe<Lhs, [0, ...Rhs], [0, ...Accumulator]>

export type IsStepSafe<Lhs extends number, Rhs extends number> = 
    _IsStepSafe<CreateRange<Lhs>, CreateRange<Rhs>>

// Utils
export type Split<Text extends string, Seperator extends string> =
    Text extends `${infer It}${Seperator}${infer Rest}` ? [It, ...Split<Rest, Seperator>] : [Text]

export type ParseInt<Text extends string> = Text extends `${infer Num extends number}`
    ? Num
    : never

export type IsIncreasingAndSafe<Input extends number[]> = 
    Input extends [infer Lhs extends number, infer Rhs extends number, ...infer Rest extends number[]]
        ? IsMoreThan<Rhs, Lhs> extends true
            ? And<IsStepSafe<Rhs, Lhs>, IsIncreasingAndSafe<[Rhs, ...Rest]>>
            : false
        : true

export type IsDecreasingAndSafe<Input extends number[]> = 
    Input extends [infer Lhs extends number, infer Rhs extends number, ...infer Rest extends number[]]
        ? IsMoreThan<Lhs, Rhs> extends true
            ? And<IsStepSafe<Lhs, Rhs>, IsDecreasingAndSafe<[Rhs, ...Rest]>>
            : false
        : true

export type IsSafe<Input extends number[]> = Or<
    IsDecreasingAndSafe<Input>,
    IsIncreasingAndSafe<Input>
>

// Split by line
export type Pipe1<Input extends string[]> =
    Input extends [infer It extends string, ...infer Rest extends string[]] // I think this is too verbose. maybe there is a better way to do this 
        ? It extends ""
            ? []
            : [Split<It, " ">, ...Pipe1<Rest>]
        : []

// Map to string
export type MapToIntArray<Input extends string[]> = 
    Input extends [infer It extends string, ...infer Rest extends string[]]
        ? [ParseInt<It> ,...MapToIntArray<Rest>]
        : []

export type Pipe2<Input extends string[][]> = 
    Input extends [infer It extends string[], ...infer Rest extends string[][]]
        ? [MapToIntArray<It> ,...Pipe2<Rest>]
        : []

// Safety check
export type Pipe3<Input extends number[][]> = 
    Input extends [infer It extends number[], ...infer Rest extends number[][]]
        ? [IsSafe<It> ,...Pipe3<Rest>]
        : []

// Count true
export type Pipe4<Input extends boolean[], Accumulator extends number[] = []> = 
    Input extends [infer It extends boolean, ...infer Rest extends boolean[]]
        ? It extends true
            ? Pipe4<Rest, [0, ...Accumulator]>
            : Pipe4<Rest, Accumulator>
    : Accumulator["length"]

export type ExampleInput = `7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
`

export type Result1 = Pipe1<Split<ExampleInput, "\n">>
export type Result2 = Pipe2<Result1>
export type Result3 = Pipe3<Result2>
export type Result4 = Pipe4<Result3>

export type Pipes<Input extends string> = Pipe4<Pipe3<Pipe2<Pipe1<Split<Input, "\n">>>>>
