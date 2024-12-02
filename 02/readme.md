# How to get the result from this
- You first need to have a typescript lsp (vscode's builtin is fine)
- open the (1|2).generated.ts
- check the type of `Result`
    - It's at the end of file
    - You can do this by hover your cursor at the `Result` type name

# Notes
- you don't need to run builder.py because i already include the generated file in the repo
- I need to split the input into smaller chunks becuase without that typescript lsp will yap about recursion depth limit or something
