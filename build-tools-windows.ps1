$projectName = ([io.fileinfo]$args[0]).BaseName
$fileDir = $args[0] + "/*.lua"

# TODO: Add -->8 between files for tab support
$result = Get-Content $fileDir | Out-String

$p8Path = $env:APPDATA + "/pico-8/carts/inktober/" + $projectName + ".p8"

(Get-Content -path $p8Path -Raw) -replace '(?ms)(?:__lua__)(.*)(?:__gfx__)', "__lua__`n$result`n__gfx__" | Set-Content -Path $p8Path

Start-Process .\reload-pico8.exe
