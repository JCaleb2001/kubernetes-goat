#!/bin/bash
# Quickstart para Kubernetes Goat sobre kind nativo en WSL2 Ubuntu (sin Docker Desktop).
# Crea el cluster (si no existe), despliega el lab, espera a que todos los pods
# esten Running y finalmente lanza los port-forwards de acceso.
set -e

CLUSTER_NAME="kubernetes-goat-cluster"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
  echo "Cluster '$CLUSTER_NAME' ya existe, reutilizando."
else
  echo "Creando cluster kind '$CLUSTER_NAME'..."
  kind create cluster --config platforms/kind-setup/kind-cluster-setup.yaml --name "$CLUSTER_NAME"
fi

bash setup-kubernetes-goat.sh

echo "Esperando a que todos los pods esten Running..."
until [ -z "$(kubectl get pods -A --no-headers 2>/dev/null | grep -v Running)" ]; do
  echo "  ...algunos pods aun no estan listos, reintentando en 5s"
  sleep 5
done
echo "Todos los pods estan Running."

bash access-kubernetes-goat.sh
