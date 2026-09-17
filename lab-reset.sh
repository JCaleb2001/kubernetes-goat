#!/bin/bash
# Resetea el lab por completo: borra el cluster kind y lo vuelve a levantar
# desde cero via wsl-quickstart.sh. Util para volver a un estado limpio
# entre ejercicios sin tener que reinstalar docker/kind/kubectl/helm.
set -e

CLUSTER_NAME="kubernetes-goat-cluster"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

echo "Eliminando cluster kind '$CLUSTER_NAME' (si existe)..."
kind delete cluster --name "$CLUSTER_NAME" || true

exec bash wsl-quickstart.sh
