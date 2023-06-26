## Powered by ChatGPT

$folderPath = '.'
$textToReplace = 'SourceGeneratorTemplate'
$replacementText = '<Your custom name>'

# Function to replace text in file
function Replace-TextInFile {
    param(
        [Parameter(Mandatory=$true)][string]$filePath
    )

    $fileContent = Get-Content -Path $filePath
    $newFileContent = $fileContent -replace $global:textToReplace, $global:replacementText

    if ($fileContent -ne $newFileContent) {
        Set-Content -Path $filePath -Value $newFileContent
    }
}

# Function to rename file
function Rename-File {
    param(
        [Parameter(Mandatory=$true)][string]$filePath
    )

    $fileName = Split-Path $filePath -Leaf
    $newFileName = $fileName -replace $global:textToReplace, $global:replacementText

    if ($fileName -ne $newFileName) {
        Rename-Item -Path $filePath -NewName $newFileName
    }
}

# Function to rename directory
function Rename-Directory {
    param(
        [Parameter(Mandatory=$true)][string]$folderPath
    )

    $folderName = Split-Path $folderPath -Leaf
    $parentPath = Split-Path $folderPath -Parent
    $newFolderName = $folderName -replace $global:textToReplace, $global:replacementText

    if ($folderName -ne $newFolderName) {
        $newFolderPath = Join-Path -Path $parentPath -ChildPath $newFolderName
        Rename-Item -Path $folderPath -NewName $newFolderPath
    }
}

## Replace text in all files, ignoring 'givename.ps1' and 'README.md'
Get-ChildItem -Path $folderPath -Recurse -File | Where-Object {
    $_.Name -ne 'givename.ps1' -and $_.Name -ne 'README.md'
} | ForEach-Object {
    Replace-TextInFile -filePath $_.FullName
}

## Rename files
Get-ChildItem -Path $folderPath -Recurse -File | ForEach-Object {
    Rename-File -filePath $_.FullName
}

## Rename directories
Get-ChildItem -Path $folderPath -Recurse -Directory | Sort-Object -Property { $_.FullName.Length } -Descending | ForEach-Object {
    Rename-Directory -folderPath $_.FullName
}
