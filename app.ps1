$header_dir = "C:\Users\zangi\Programmering\lab3\ps"

$sigPath = "C:\Users\zangi\Programmering\lab3\ps\siglist.txt"

$sigList = Import-Csv -Path "$sigPath" -Delimiter ";" -header "fileExtension", "firstValue", "lastValue"


Get-ChildItem $header_dir -Recurse -Include *.*| ForEach-Object {
    $file = $_.FullName
    $fileLenght = $_.Length
    $fileTypeIs = [System.IO.Path]::GetExtension($file)
    $fileName = $file.Substring($file.LastIndexOf("\") + 1)
    $firstLine = (Get-Content $file -Encoding Byte -TotalCount $fileLenght)
    $hexValues = $firstLine | ForEach-Object {
        $_ | ForEach-Object {
            '{0:X2}' -f $_
        }
    }
    $hexValues = $hexValues -join ''
    $lastFour = $hexValues.Substring($hexValues.Length-4)
    $firstValue = $s.firstValue


    foreach($s in $sigList)
    {
        if($s.lastValue -ne ""){
            if($fileTypeIs -eq $s.fileExtension){
                if(($hexValues.StartsWith($s.firstValue) -and ($lastFour -eq $s.lastValue))){
                    Write-Output "FileName: $fileName Type: $fileTypeIs | SigFirst: $firstValue FileFirst: $firstFour | SigLast: $lastValue  FileLast: $lastFour || VALID 1"
                }
                else{
                    Write-Output "FileName: $fileName Type : $fileTypeIs | SigValue: $firstValue FileValue $firstFour| SigLast: $lastValue  FileLast: $lastFour || ROUGE 1"
                }
                break
            }
        }
        if($s.lastValue -eq ""){
            if($fileTypeIs -eq $s.fileExtension){
                if($hexValues.StartsWith($s.firstValue)){
                    Write-Output "FileName: $fileName Type: $fileTypeIs | SigFirst: $firstValue FileFirst: $firstFour | SigLast: $lastValue  FileLast: $lastFour || VALID 2"
                }
                else{
                    Write-Output "FileName: $fileName Type : $fileTypeIs | SigValue: $firstValue FileValue $firstFour| SigLast: $lastValue  FileLast: $lastFour || ROUGE 2"
                }
                break
            }
        }
    }
}