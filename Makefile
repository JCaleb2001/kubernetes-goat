CLUSTER_NAME := kubernetes-goat-cluster

.PHONY: up down reset access status

up:
	bash wsl-quickstart.sh

down:
	-bash teardown-kubernetes-goat.sh
	-kind delete cluster --name $(CLUSTER_NAME)

reset: down up

access:
	bash access-kubernetes-goat.sh

status:
	kubectl get pods -A
