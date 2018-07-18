$folder1 = "/Users/alan/Downloads/var1"
$folder2 = "/Users/alan/Downloads/var2"

$removeFilesOnlyInFolder1 = $false
$removeFilesOnlyInFolder2 = $false
$removeIdenticalFiles = $true
$removeDifferentFiles = $false

Get-ChildItem -Path $folder1 -Recurse | ForEach-Object {
    if ($_.Attributes -ne "Directory")
    {
        $relativeName = $_.FullName.Substring($folder1.Length)

        if ((Test-Path -Path ($folder2 + $relativeName)))
        {
            # compare checksums
            $sum1 = md5 -q $_.FullName
            $sum2 = md5 -q ($folder2 + $relativeName)
            if ($sum1 -eq $sum2)
            {
                "Identical: $relativeName"
                if ($removeIdenticalFiles)
                {
                    Remove-Item -Path $_.FullName
                    Remove-Item -Path ($folder2 + $relativeName)
                }
            }
            else
            {
                "Different: $relativeName"
                if ($removeDifferentFiles)
                {
                    Remove-Item -Path $_.FullName
                    Remove-Item -Path ($folder2 + $relativeName)                   
                }
            }
        }
        else {
            "New File: $relativeName"
            if ($removeFilesOnlyInFolder1)
            {
                Remove-Item $_.FullName
            }
        }
    }
}

# simpler check for files in second folder that aren't in first
Get-ChildItem -Path $folder2 -Recurse | ForEach-Object {
    $relativeName = $_.FullName.Substring($folder2.Length)

    if ((Test-Path -Path ($folder1 + $relativeName)) -eq $false)
    {
        "Deleted: $relativeName"
        if ($removeFilesOnlyInFolder2)
        {
            Remove-Item -Path $_.FullName
        }
    }
}