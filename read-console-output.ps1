
function Read-BufferHistory ($lineCount) {
    # Initialize string builder.
    $textBuilder = new-object system.text.stringbuilder

    $bufferWidth = $host.ui.rawui.BufferSize.Width
    $bufferHeight = $host.ui.rawui.CursorPosition.Y
    $rec = new-object System.Management.Automation.Host.Rectangle 0, 0, ($bufferWidth – 1), $bufferHeight
    $buffer = $host.ui.rawui.GetBufferContents($rec)

    $startLine = $bufferHeight - $lineCount
    if ($startLine -lt 0) {
        $startLine = 0
    }

    for ($i = $startLine; $i -lt $bufferHeight; $i++) {
        for ($j = 0; $j -lt $bufferWidth; $j++) {
            $cell = $buffer[$i, $j]
            $null = $textBuilder.Append($cell.Character)
        }
        $null = $textBuilder.Append("`r`n")
    }
    return $textBuilder.ToString()
}

Write-Host "Some stuff I had to say"
Write-Host "More stuff I had to say"


$bufferHistory = Read-BufferHistory 2

Write-Host ""
Write-Host "Here what I heard..." -ForegroundColor Cyan
$bufferHistory

