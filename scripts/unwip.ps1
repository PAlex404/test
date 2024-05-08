# Function to check if the current directory is a Git repository
function IsGitRepository {
    return (Test-Path -Path ".git" -PathType Container)
}

# Loop to navigate up the directory tree until a Git repository is found
while (-not (IsGitRepository)) {
    # Change directory up one level
    Set-Location ..
    
    # Check if at root directory
    if ((Get-Location).Path -eq (Get-Location -PSProvider FileSystem).Root) {
        Write-Host "Not in a Git repository" -ForegroundColor red
        break
    }
}

if (IsGitRepository) {
    Write-Host "Git repository found at: $(Get-Location)" -ForegroundColor green
}

Write-Host "Searching for wip commit..." -ForegroundColor green
if ($(git log -1 --pretty=%B) -contains "--wip--") {
Write-Host "Wip commit found. Resetting..." -ForegroundColor green
git reset HEAD~1
} else {
Write-Host "Wip commit not found" -ForegroundColor red
}