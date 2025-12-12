function Invoke-BeforeBuild {
  param (
    #[string]$CallerScriptFolder
  )


  #$ProjectFile = Get-ChildItem -Path $CallerScriptFolder -Filter *.csproj | Select-Object -First 1

  Write-Host "執行前置作業..."
  cd ..

  

  # 讀取要共用的 README 檔案內容
  $mdShareContent = Get-Content -Path "./README.Share.md" -Raw

  Invoke-RebuildMD "README.md" $mdShareContent
  Invoke-RebuildMD "README.zh-tw.md" $mdShareContent
}

function Invoke-RebuildMD {
  param (
    [string]$fileName,
    [string]$shareContent
  )

  # 讀取內容  
  $readmeText = Get-Content $fileName -Raw
  
  # 用正則取代 <!-- share_start --> 到 <!-- share_end --> 之間的內容
  $pattern = '(?s)(<!-- share_start -->).*?(<!-- share_end -->)'
  $replacement = "`$1`n$shareContent`n`$2"
  $newReadme = [regex]::Replace($readmeText, $pattern, $replacement)

  # 統一行尾符號為 CRLF
  $newReadme = [regex]::Replace($newReadme, "\r\n|\r|\n", "`r`n")

  # 移除最後多餘的換行
  $newReadme = $newReadme.TrimEnd("`r", "`n")
  
  # 寫回檔案
  Set-Content $fileName -Value $newReadme
}
