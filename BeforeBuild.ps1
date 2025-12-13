function Invoke-BeforeBuild {
  param (

  )

  Write-Host "執行重建 README 作業開始"

  # 切換到專案根目錄
  cd ..

  # 讀取要共用的 README 檔案內容
  $readmeShare = Get-Content -Path "./README.Share.md" -Raw

  Invoke-RebuildMD "README.md" $readmeShare
  Invoke-RebuildMD "README.zh-tw.md" $readmeShare

  Write-Host "執行重建 README 作業結束"
}

function Invoke-RebuildMD {
  param (
    [string]$fileName,
    [string]$readmeShare
  )
  Write-Host "重建 $fileName 作業開始"

  # 讀取內容  
  $readmeText = Get-Content $fileName -Raw
  
  # 用正則取代 <!-- share_start --> 到 <!-- share_end --> 之間的內容
  $pattern = '(?s)(<!-- share_start -->).*?(<!-- share_end -->)'
  $replacement = "`$1`n$readmeShare`n`$2"
  $newReadme = [regex]::Replace($readmeText, $pattern, $replacement)

  # 統一行尾符號為 CRLF
  $newReadme = [regex]::Replace($newReadme, "\r\n|\r|\n", "`r`n")

  # 移除最後多餘的換行
  $newReadme = $newReadme.TrimEnd("`r", "`n")
  
  # 寫回檔案
  Set-Content $fileName -Value $newReadme

  Write-Host "重建 $fileName 作業結束"
}

Invoke-BeforeBuild
