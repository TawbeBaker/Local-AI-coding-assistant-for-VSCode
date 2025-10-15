# restart_ollama.ps1
# Gracefully restarts Ollama service or process on Windows

Write-Host "🔁 Restarting Ollama..."

# Try stopping Ollama process if it exists
Get-Process -Name ollama -ErrorAction SilentlyContinue | Stop-Process -Force

# Start Ollama again
Start-Process -FilePath "ollama" -ArgumentList "serve"

Write-Host "✅ Ollama restarted successfully."
