
#!/usr/bin/env bash
set -e

log() {
    echo "[SCRIPT] $1"
}

# Override python binary with first parameter: ./script/build_backend.sh /usr/local/bin/python3.9
PYTHON_BIN="${1:-python3}"
log "Using python: $PYTHON_BIN"

# Go into backend folder
log "cd into ./Ansible"
cd ./Ansible

# Make sure we have python 3.5 or newer
log "Make sure we use python 3.5 or newer"
$PYTHON_BIN -c "import sys; assert sys.version_info >= (3, 5), 'Python 3.5 or newer is required to build. Currently using: {}'.format(sys.version_info)"

# Create venv
log "Creating venv"
virtualenv --python $PYTHON_BIN venv

# Update package tools in venv
log "Update package tools in venv"
./venv/bin/pip install -U pip setuptools wheel build

# Build wheel dist for backend
log "Building wheel"
# "do not isolate the build in a virtual environment" because we are already in a venv
# "build a wheel" what we want to build
./venv/bin/python -m build --no-isolation --wheel

# Copy wheel to expected location
log "Copy wheel to: ../ansible/playbooks/files/energy_status_page.whl"
cp dist/*.whl ../home/oh856/XBID-ANALYTICS-DASH/pki_collectors.whl