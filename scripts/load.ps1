function global:aoc {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )
    
    $scriptPath = "$($PSScriptRoot)\aoc.py"
    
    # Write-Output $scriptPath
    python $scriptPath @args
}

function global:unload {
    Remove-Item -Path function:deactivate
    Remove-Item -Path function:aoc
}
# Write-Output $MyInvocation.MyCommand.Definition

# Write-Output "Function 'aoc' has been declared for this session."
