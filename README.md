# ComfyUI launcher

- **Windows:** doble clic en `start_comfyui.bat`
- **Linux/Mac:** `./start_comfyui.sh` (sin GPU: `./start_comfyui.sh --cpu`)

Abre automaticamente http://127.0.0.1:8188.

## Si no abre
- Necesitas Git y Python 3.10–3.12 en el PATH.
- Puerto ocupado: `python main.py --port 8189`.
- Error de CUDA / sin GPU NVIDIA: `python main.py --cpu`.
- Tras un fallo de instalacion borra la carpeta `ComfyUI\venv` y ejecuta de nuevo.
