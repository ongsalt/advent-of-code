import { And, ExampleInput, IsMoreThan, IsStepSafe, Or, Pipe1, Pipe2, Pipe4, Split } from "./1"

type IsIncreasingAndSafe<Input extends number[], Autoremoved extends boolean = false, IsAtStart extends boolean = true> = 
    Input extends [infer Lhs extends number, infer Rhs extends number, ...infer Rest extends number[]]
        ? And<
            IsMoreThan<Rhs, Lhs>,
            And< 
                IsIncreasingAndSafe<[Rhs, ...Rest], Autoremoved, false>,
                IsStepSafe<Rhs, Lhs>
            > 
        > extends true
            ? true
            : Autoremoved extends false
                ? Or<
                    IsIncreasingAndSafe<[Lhs, ...Rest], true, false>,
                    // We will try to remove rhs only when it's the beginning of array
                    IsAtStart extends true 
                        ? IsIncreasingAndSafe<[Rhs, ...Rest], true, false>
                        : false
                >
                : false
        : true

type IsDecreasingAndSafe<Input extends number[], Autoremoved extends boolean = false, IsAtStart extends boolean = true> = 
    Input extends [infer Lhs extends number, infer Rhs extends number, ...infer Rest extends number[]]
    ? And<
        IsMoreThan<Lhs, Rhs>,
        And< 
            IsDecreasingAndSafe<[Rhs, ...Rest], Autoremoved, false>,
            IsStepSafe<Lhs, Rhs>
        > 
    > extends true
        ? true
        : Autoremoved extends false
            ? Or<
                IsDecreasingAndSafe<[Lhs, ...Rest], true, false>,
                // We will try to remove rhs only when it's the beginning of array
                IsAtStart extends true 
                    ? IsDecreasingAndSafe<[Rhs, ...Rest], true, false>
                    : false
            >
            : false
    : true

type IsSafe<Input extends number[]> = Or<
    IsDecreasingAndSafe<Input>,
    IsIncreasingAndSafe<Input>
>

type Pipe3<Input extends number[][]> = 
    Input extends [infer It extends number[], ...infer Rest extends number[][]]
        ? [IsSafe<It> ,...Pipe3<Rest>]
        : []

export type Pipes<Input extends string> = Pipe4<Pipe3<Pipe2<Pipe1<Split<Input, "\n">>>>>

type Test1 = IsIncreasingAndSafe<[1, 3, 2, 4, 5]>
type Test2 = IsIncreasingAndSafe<[1, 3, 6, 7, 9]>
type Test3 = IsIncreasingAndSafe<[9, 3, 6, 7, 90]>
type Test4 = IsIncreasingAndSafe<[1, 2, 7, 8, 9]>

type Result = Pipes<ExampleInput>