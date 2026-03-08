mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"

  # Ghidra
  # As of March 6, 2026, the latest official Ghidra release page shows 12.0.4.
  # The direct zip URL below is inferred from Ghidra's documented release-file naming convention.
cd "$HOME/.local/opt"
curl -L -O https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.0.4_build/ghidra_12.0.4_PUBLIC_20260303.zip
unzip -oq ghidra_12.0.4_PUBLIC_20260303.zip
ln -sfn "$HOME/.local/opt/ghidra_12.0.4_PUBLIC/ghidraRun" "$HOME/.local/bin/ghidraRun"

  # SageMath
cd "$HOME/.local/opt"
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash "Miniforge3-$(uname)-$(uname -m).sh" -b -p "$HOME/.local/miniforge3"
"$HOME/.local/miniforge3/bin/conda" config --set auto_activate_base false
"$HOME/.local/miniforge3/bin/conda" create -y -n sage sage python=3.12
printf '%s\n' '#!/usr/bin/env bash' 'exec "$HOME/.local/miniforge3/bin/conda" run -n sage sage "$@"' > "$HOME/.local/bin/sage"
chmod +x "$HOME/.local/bin/sage"

# Optional: Volatility3
pipx install volatility3 || pipx upgrade volatility3
