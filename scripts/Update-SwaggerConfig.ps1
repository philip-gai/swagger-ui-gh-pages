<#
  .SYNOPSIS
  Updates the swagger-config.json file with the urls from the specs folder.
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false)]
    [String]$RepoFolder = "swagger-ui-simple/",

    [Parameter(Mandatory=$false)]
    [String]$SpecFolder = "./specs/",

    [Parameter(Mandatory=$false)]
    [String]$OutFile = "./swagger-config.json"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Install-Module powershell-yaml -Force
}
Import-Module powershell-yaml

$files = Get-ChildItem $SpecFolder -Recurse -File | Select-Object FullName, Extension

$swaggerConfig = @{}
$swaggerConfig.urls = @()

foreach ($file in $files) {
    $url = $file.FullName.split($RepoFolder)[1]
    if ($file.Extension -eq ".json") {
        $spec = Get-Content $file.FullName | ConvertFrom-Json
    } elseif ($file.Extension -eq ".yaml" -or $file.Extension -eq ".yml") {
        $spec = Get-Content $file.FullName | ConvertFrom-Yaml
    } else {
        Write-Error "Unsupported file type: $($file.Extension)"
    }
    $name = $spec.info.title
    $swaggerConfig.urls += [PSCustomObject]@{
        url = $url
        name = $name
    }
}

[array]$swaggerConfig.urls = $swaggerConfig.urls | Sort-Object -Property url | Sort-Object -Property name -Unique
Write-Host $swaggerConfig.urls

$swaggerConfig | ConvertTo-Json | Out-File $OutFile -Encoding utf8 -Force
