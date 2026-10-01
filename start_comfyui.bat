@echo off
REM Instala (si hace falta) y abre ComfyUI en Windows
setlocal
cd /d "%~dp0"
if not exist ComfyUI (
  git clone https://github.com/comfyanonymous/ComfyUI.git || goto :err
)
cd ComfyUI
if not exist venv (
  python -m venv venv || goto :err
  call venv\Scripts\activate.bat
  python -m pip install --upgrade pip
  REM GPU NVIDIA. Sin NVIDIA usa: pip install torch torchvision torchaudio
  pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
  pip install -r requirements.txt || goto :err
) else (
  call venv\Scripts\activate.bat
)
start "" http://127.0.0.1:8188
python main.py
pause
exit /b 0
:err
echo.
echo ERROR: revisa que Git y Python 3.10-3.12 esten instalados y en el PATH.
pause
exit /b 1
