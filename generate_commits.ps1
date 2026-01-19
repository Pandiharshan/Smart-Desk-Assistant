# PowerShell script to generate commits from Jan 1 to Jun 4
# Random commits per day: 5-12

$startDate = Get-Date "2025-01-01"
$endDate = Get-Date "2025-06-04"

$currentDate = $startDate

while ($currentDate -le $endDate) {
    # Random number of commits between 5 and 12
    $commitsPerDay = Get-Random -Minimum 5 -Maximum 13
    
    Write-Host "Processing $($currentDate.ToString('yyyy-MM-dd')) - $commitsPerDay commits"
    
    for ($i = 0; $i -lt $commitsPerDay; $i++) {
        # Random hour and minute for the commit
        $hour = Get-Random -Minimum 8 -Maximum 23
        $minute = Get-Random -Minimum 0 -Maximum 60
        
        $commitDate = $currentDate.AddHours($hour).AddMinutes($minute)
        $dateString = $commitDate.ToString("yyyy-MM-ddTHH:mm:ss")
        
        # Modify a file (append a line to README.md)
        Add-Content -Path "README.md" -Value "Update: $dateString"
        
        # Stage and commit
        git add README.md
        
        $env:GIT_AUTHOR_DATE = $dateString
        $env:GIT_COMMITTER_DATE = $dateString
        
        git commit -m "Update $dateString" --date="$dateString"
    }
    
    # Move to next day
    $currentDate = $currentDate.AddDays(1)
}

Write-Host "Done! Generated commits from Jan 1 to Jun 4, 2025"
Write-Host "Run 'git push' to push the commits to remote repository"
