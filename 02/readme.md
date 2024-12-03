# How to use this
- Get an input put them into `input.txt` in this directory
- Run builder.py to split those input into smaller chunks becuase without that typescript lsp will yap about recursion depth limit or something
- You also need a typescript lsp (vscode's builtin is fine)
- Open the `(1|2).generated.ts`
- Check the type of `Result`
    - It's at the end of file
    - You can do this by hover your cursor at the `Result` type name
