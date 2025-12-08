# 参考: ./.azdo/templates/build-win32-openssh-job.yml

$vcpkgObj = Get-Content "contrib/win32/openssh/vcpkg.json" | ConvertFrom-Json
$libresslVersionJson = $vcpkgObj | Select-Object -ExpandProperty overrides | Where-Object { $_.name -eq 'libressl' } | Select-Object -ExpandProperty version
# resource file version needs to be trimmed (e.g. 4.0.0.0 to 4.0.0)
$patchContent = Get-Content "contrib/win32/openssh/vcpkg_overlay_ports/libressl/add-version-file.patch"
$libresslVersionPatch = ($patchContent -join "`n" | Select-String -Pattern '"FileVersion",\s*"(\d+\.\d+\.\d+\.\d+)"' -AllMatches).Matches | ForEach-Object { $_.Groups[1].Value }
$libresslVersionPatchParts = $libresslVersionPatch -split '\.'
$libresslVersionPatchShort = ($libresslVersionPatchParts[0..2] -join '.')

if ($libresslVersionJson -ne $libresslVersionPatchShort) {
      Write-Error "LibreSSL version mismatch: vcpkg.json has $libresslVersionJson, patch file has $libresslVersionPatch"
      exit 1
} else {
      Write-Verbose -Verbose "LibreSSL versions match: $libresslVersionJson"
}


# vcpkg 
#git clone --depth=1 https://github.com/microsoft/vcpkg
git clone https://github.com/microsoft/vcpkg
cd vcpkg
#git checkout a345bbdc68cdfda65603e24413b21afb28f110fb
& ./bootstrap-vcpkg.bat
& ./vcpkg.exe integrate install
	
# build 
cd ..
$nativeArch = 'x64'
Import-Module -Name "./contrib/win32/openssh/AzDOBuildTools" -Force
Invoke-AzDOBuild -NativeHostArch $nativeArch

# 结果应该在 "$(Build.SourcesDirectory)/bin"


