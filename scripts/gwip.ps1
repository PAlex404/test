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

Write-Host "Deleting files..." -ForegroundColor green
git ls-files --deleted

Write-Host "Adding files..." -ForegroundColor green
git add -A

Write-Host "Preparing commit..." -ForegroundColor green
if ($(git log -1 --pretty=%B) -contains "--wip--") {
Write-Host "Amending..." -ForegroundColor yellow
git commit --no-verify --no-gpg-sign --amend -m "--wip--"
Write-Host "Force pushing" -ForegroundColor red
git push -f
} else {
git commit --no-verify --no-gpg-sign -m "--wip--"
Write-Host "Pushing" -ForegroundColor green
git push
}
