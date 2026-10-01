#!/usr/bin/env bash
# Instala (si hace falta) y abre ComfyUI en Linux/Mac
set -e
cd "$(dirname "$0")"
[ -d ComfyUI ] || git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
if [ ! -d venv ]; then
  python3 -m venv venv
  . venv/bin/activate
  pip install --upgrade pip
  # NVIDIA: cu124. Mac (Apple Silicon): torch normal. Sin GPU: añade --cpu al final.
  if command -v nvidia-smi >/dev/null; then
    pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
  else
    pip install torch torchvision torchaudio
  fi
  pip install -r requirements.txt
else
  . venv/bin/activate
fi
(sleep 4; xdg-open http://127.0.0.1:8188 2>/dev/null || open http://127.0.0.1:8188 2>/dev/null || true) &
python main.py "$@"
