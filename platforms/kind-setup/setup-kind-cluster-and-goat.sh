#!/bin/bash
# Author: Mauricio Cano
# This file has been created to contribute to the development of the Kubernetes Goat

# Check that kind is installed
kind version > /dev/null 2>&1 
if [ $? -eq 0 ];
then
    echo "Kind is installed, all good"
else 
    echo "Please install Kind to use this setup file"
    exit;
fi

# Check that docker is installed in the host
docker version --format '{{.Server.Version}}' > /dev/null 2>&1 
if [ $? -eq 0 ];
then
    echo "Docker is installed, all good"
else 
    echo "Please install Docker to use this setup file"
    exit;
fi

# Setup cluster using extraMounts to expose the docker socket from the host
kind create cluster --config kind-cluster-setup.yaml --name kubernetes-goat-cluster

# Move to the root dir
cd ../..

# Setup GOAT exposing host Docker socket:
# NOTE: use bash, not sh -- on Debian/Ubuntu (incl. WSL2) /bin/sh is dash,
# which doesn't support the [[ ]] / case-shift-2 syntax used in this script.
bash setup-kubernetes-goat.sh
