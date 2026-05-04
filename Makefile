# Usage:
# make build
# make blue-green
# make canary
# make clean-bg
# make clean-canary
# make help

build:
	docker build -t myapp:v1 -f docker/Dockerfile app/v1
	docker build -t myapp:v2 -f docker/Dockerfile app/v2

blue-green:
	kubectl apply -f k8s/blue-green/

canary:
	kubectl apply -f k8s/canary/

clean-bg:
	kubectl delete -f k8s/blue-green/ || true

clean-canary:
	kubectl delete -f k8s/canary/ || true

test:
	k6 run -e BASE_URL=http://$(shell minikube ip):30007 k6/load-test.js || true

help:
	@echo "Available commands:"
	@echo "  make build        - Build Docker images"
	@echo "  make blue-green   - Deploy Blue/Green strategy"
	@echo "  make canary       - Deploy Canary strategy"
	@echo "  make clean-bg     - Remove Blue/Green resources"
	@echo "  make test         - Run load tests"
	@echo "  make clean-canary - Remove Canary resources"
