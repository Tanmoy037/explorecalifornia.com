.PHONY: run_website stop_website install_kind create_kind_cluster \
	delete_kind_cluster delete_docker_registry install_app


run_website:
	docker build -t explorecalifornia.com . && \
		docker run --rm --name exploreclifornia.com -p 5000:80 -d exploreclifornia.com

stop_website:
	docker stop exploreclifornia.com

install_kubectl:
	brew install kubectl || true;

install_kind:
	curl --location --output ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.17.0/kind-linux-amd64 && \
		./kind --version
	
connect_registry_to_kind_network:
	docker network connect kind local-registry || true;

connect_registry_to_kind: connect_registry_to_kind_network
	kubectl apply -f ./kind_configmap.yaml;

create_docker_registry:
	if ! docker ps | grep -q 'local-registry'; \
	then docker run -d -p 5000:5000 --name local-registry --restart=always registry:2; \
	else echo "---> local-registry is already running. There's nothing to do here."; \
	fi

create_kind_cluster: install_kind install_kubectl create_docker_registry
	kind create cluster --image=kindest/node:v1.21.12 --name explorecalifornia.com --config ./kind_config.yaml || true
	kubectl get nodes

create_kind_cluster_with_registry:
	$(MAKE) create_kind_cluster && $(MAKE) connect_registry_to_kind

delete_kind_cluster: delete_docker_registry
	kind delete cluster --name explorecalifornia.com

delete_docker_registry:
	docker stop local-registry && docker rm local-registry

install_app:
	helm upgrade --atomic --install explorecalifornia.com ./chart






		

