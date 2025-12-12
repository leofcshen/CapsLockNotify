function Invoke-BeforeBuild {
  param (
    #[string]$CallerScriptFolder
  )


  #$ProjectFile = Get-ChildItem -Path $CallerScriptFolder -Filter *.csproj | Select-Object -First 1

  Write-Host "執行前置作業..."
  cd ..

  # 讀取要共用的 README 檔案內容
  $mdShareContent = Get-Content -Path "./README.Share.md" -Raw
  
  # 讀取 README.md
  $readmePath = "README.md"
  $readmeText = Get-Content $readmePath -Raw
  
  # 用正則取代 <!-- share_start --> 到 <!-- share_end --> 之間的內容
  $pattern = '(?s)(<!-- share_start -->).*?(<!-- share_end -->)'
  $replacement = "`$1`n$mdShareContent`n`$2"
  $newReadme = [regex]::Replace($readmeText, $pattern, $replacement)
  
  # 寫回 README.md
  Set-Content $readmePath -Value $newReadme


  # 讀取 README.zh-tw.md
  $readmePath = "README.zh-tw.md"
  $readmeText = Get-Content $readmePath -Raw
  
  # 用正則取代 <!-- share_start --> 到 <!-- share_end --> 之間的內容
  $pattern = '(?s)(<!-- share_start -->).*?(<!-- share_end -->)'
  $replacement = "`$1`n$mdShareContent`n`$2"
  $newReadme = [regex]::Replace($readmeText, $pattern, $replacement)
  
  # 寫回 README.zh-tw.md
  Set-Content $readmePath -Value $newReadme
}
