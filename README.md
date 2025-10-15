# 🧠 Local AI Copilot: Run a Fully Local Coding Assistant

> A step-by-step guide to set up your own **GitHub Copilot alternative** using **Ollama**, **VS Code**, and **Continue.dev**, running entirely **on your local GPU** ; no cloud, no limits.

---

## 🚀 Overview

This project demonstrates how to create a **local AI development assistant** on Windows.  
Instead of relying on paid or rate-limited tools like GitHub Copilot or Claude for VS Code, you’ll run a **local LLM (Large Language Model)** that helps you **generate code, refactor, and run commands directly inside VS Code**.

✅ **All processing happens locally** ; perfect for privacy, offline coding, and reproducibility.  
✅ **GPU-accelerated** ; uses your NVIDIA GPU (e.g., RTX 3080 or higher).  
✅ **Free and open-source stack** ; based on Ollama and Continue.dev.

---

## 🧩 Components

| Tool | Role | Link |
|------|------|------|
| **Ollama** | Local LLM runtime | [https://ollama.com](https://ollama.com) |
| **Continue.dev** | VS Code extension that connects to local or remote models | [https://continue.dev](https://continue.dev) |
| **VS Code** | IDE integration and chat interface | [https://code.visualstudio.com](https://code.visualstudio.com) |

---

## ⚙️ My Specs :
> ( you can use pretty much anything, including cpu computing, MacOS, Linux etc. -> The commands might change a bit, for example, instead of winget, you use curl -fsSL https://ollama.ai/install.sh | sh on linux)

- **Windows 10/11**
- **NVIDIA GPU** (RTX 3080 or higher recommended)
- **VS Code** installed
- **PowerShell** (optional but convenient)
- Sufficient disk space (10–20 GB for model storage)

Check GPU status:
```powershell
nvidia-smi
```

---

## 🛠️ Step-by-Step Setup Guide

### 1. (Optional) Install PowerShell

```powershell
winget install Microsoft.PowerShell
```

You can also use VS Code’s built-in terminal or install it from the microsoft website using the GUI which is easier.

---

### 2. Install Ollama

```powershell
winget install Ollama.Ollama
```

This installs both the **Ollama GUI** and the **CLI (command-line interface)**.

If you prefer manual installation without the terminal:  
Download from [https://ollama.com/download](https://ollama.com/download)

---

### 3. Add Ollama to PATH (if needed)

If `ollama` is not recognized in PowerShell:

```powershell
setx Path "$($env:Path);C:\Users\$env:USERNAME\AppData\Local\Programs\Ollama"
```

It is important to understand what you are running on your computer, therefore always read the command. In this case, USERNAME should be replace by the actual username of the computer.

Then **restart PowerShell or VS Code**.

Verify:
```powershell
ollama --version
```

---

### 4. Enable GPU Acceleration
>, if you are using a GPU (graphics card) as mine by default used CPU, which was slow. 

Enable GPU usage globally:
```powershell
setx OLLAMA_USE_GPU 1
```

Restart terminal and Ollama afterward.

---

### 5. Restart Ollama

If the GUI is open:
1. Right-click the Ollama tray icon → **Exit**
2. Close all Ollama windows

Then run:
```powershell
ollama serve
```

If Ollama is running as a background process:
```powershell
Get-Process -Name ollama -ErrorAction SilentlyContinue | Stop-Process -Force
ollama serve
```

---

### 6. Pull a Model

Visit the Ollama model library:  
🔗 [https://ollama.com/library](https://ollama.com/library)

Choose a model (e.g., `mistral`, `deepseek-coder`, `llama3`, etc.)  
Then pull it locally:
```powershell
ollama pull mistral
```
> I personally used ollama pull deepseek-coder

You can test it directly:
```powershell
ollama run mistral
```

> 💡 Check GPU activity using `nvidia-smi` ; you should see `ollama` using VRAM while generating text.

---

### 7. Install Continue.dev in VS Code

1. Open VS Code → Extensions sidebar
2. Search for **Continue**
3. Install the official **Continue.dev** extension  
   or run:
   ```
   Ctrl + P → ext install Continue.continue
   ```

Launch Continue:
```
Ctrl + L
```
Select **Ollama** when prompted, or in the left bottom side of the dialogue box ; it should auto-detect your local server at:
```
http://localhost:11434
```

If it doesn’t, follow the next step to configure it manually.

---

## 🧰 Configuration (Optional)

### `.continue/config.json`
Place this file in your home directory or inside your project:

```json
{
  "models": [
    {
      "title": "Ollama Mistral",
      "provider": "ollama",
      "model": "mistral"
    },
    {
      "title": "Deepseek Coder",
      "provider": "ollama",
      "model": "deepseek-coder"
    }
  ]
}
```

### `.continue/modes/localCoder.json`
This defines a reusable chat mode for consistent assistant behavior:

```json
{
  "title": "Local Coding Assistant",
  "description": "Use Mistral via Ollama for precise, reproducible coding assistance.",
  "model": {
    "provider": "ollama",
    "model": "mistral"
  },
  "systemMessage": "You are a concise, accuracy-first coding assistant. Always return runnable code and clear explanations."
}
```

---

## 💡 Example Quick Test

1. Run the Ollama server:
   ```powershell
   ollama serve
   ```
2. Open VS Code → Continue → Start chat
3. Ask:
   > “Write a Python function to compute SHA256 hash of a file.”

4. The model (Mistral) will respond locally using your GPU.

---

## 🧩 Troubleshooting

| Problem | Cause | Fix |
|----------|--------|-----|
| `ollama` not recognized | PATH not updated | Add Ollama folder to PATH and restart terminal |
| Ollama not using GPU | GPU variable not set | Run `setx OLLAMA_USE_GPU 1` and restart |
| Service not found (`OllamaService`) | GUI mode | Close GUI and restart manually with `ollama serve` |
| Out of VRAM | Model too large | Use smaller / quantized model (e.g., `mistral:7b-q4_0`) |
| Continue doesn’t detect Ollama | API not reachable | Ensure Ollama is running at `http://localhost:11434` |

---

## 🔁 Optional PowerShell Scripts

### `scripts/setup_ollama.ps1`
```powershell
# Configure environment for GPU and add Ollama to PATH
setx OLLAMA_USE_GPU 1
$ollamaPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Ollama"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $ollamaPath, [EnvironmentVariableTarget]::User)
Write-Host "Restart terminal after running this script."
```

### `scripts/restart_ollama.ps1`
```powershell
# Restart Ollama manually (non-service mode)
Get-Process -Name ollama -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Process -FilePath "ollama" -ArgumentList "serve"
Write-Host "Ollama restarted successfully."
```

---

## 🧠 Notes & Best Practices

- Use **7B quantized models** for 10 GB VRAM GPUs like RTX 3080.
- In general 1B = 1GB, although I have managed to run 32B models ona 3090 24GB. (It depends on quantization, algorithms, etc.)  
- Always restart Ollama after changing environment variables.  
- Keep your `.continue` configuration versioned in Git for consistency.  
- If sharing this setup with a team, create a `models.txt` listing all models used.

---

<details>
<summary>✅ Quick Setup Checklist (click to expand)</summary>

- [ ] Install Ollama → `winget install Ollama.Ollama`
- [ ] Enable GPU → `setx OLLAMA_USE_GPU 1`
- [ ] Add Ollama to PATH if needed
- [ ] Restart Ollama (`ollama serve`)
- [ ] Pull a model (`ollama pull mistral`)
- [ ] Install Continue.dev in VS Code
- [ ] Open Continue → select Ollama

</details>

---

## 💬 Example Usage

Inside VS Code Continue panel, as a remplacememnt for Copilot:
> 💡 “Create a TypeScript file structure for a REST API with Express.js.”

You’ll see the model generate folders, files, and example code locally ; just like Copilot, but **private and free**.

---

## 🏁 Result

You now have:
- A **local AI assistant** that writes and refactors code directly in VS Code  
- **Zero cloud dependencies**  
- **Full control and reproducibility**

This setup can be shared internally with developers or demonstrated to employers as a **practical local AI integration project**.

---

Created by **[Baker]**  
📍 *Local AI Engineering & Developer Tools Enthusiast*
