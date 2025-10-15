# setup_ollama.ps1
# Sets up environment variables and PATH for Ollama on Windows

Write-Host "🔧 Configuring Ollama environment..."

# Enable GPU support
setx OLLAMA_USE_GPU 1

# Add Ollama to PATH
$ollamaPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Ollama"
if (-Not ($env:Path -like "*$ollamaPath*")) {
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $ollamaPath, [EnvironmentVariableTarget]::User)
    Write-Host "✅ Ollama path added to user environment."
} else {
    Write-Host "ℹ️ Ollama path already in environment."
}

Write-Host "🎉 Setup complete. Please restart your terminal or VS Code."
