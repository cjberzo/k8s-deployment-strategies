# 🚀 Kubernetes Deployment Strategies Demo

This project demonstrates **Blue/Green** and **Canary** deployment strategies using Kubernetes, Docker, and a simple Python (FastAPI) application.

# 📌 Overview

The goal of this project is to showcase modern deployment strategies that allow:

* Zero-downtime deployments
* Safe release rollouts
* Traffic control between application versions

The application exposes a simple HTTP endpoint returning:

```json
{
  "version": "v1 | v2",
  "hostname": "<pod-name>"
}
```

# 🛠️ Tech Stack

* Kubernetes (Minikube)
* Docker
* Python (FastAPI)
* k6 (Load Testing)
* Makefile (optional)

## 📦 Prerequisites

- Docker installed
- Minikube installed
- kubectl installed
- k6 installed (for load testing)


# ⚙️ Setup Instructions

## 1. Start Kubernetes cluster

```bash
minikube start --driver=docker
```

## 2. Use Minikube Docker daemon

```bash
eval $(minikube docker-env)
```

## 3. Build Docker Images

```bash
docker build -t myapp:v1 -f docker/Dockerfile app/v1
docker build -t myapp:v2 -f docker/Dockerfile app/v2
```
or

```bash
make build    
```

# 🔵🟢 Blue/Green Deployment

## Description

Two identical environments are deployed:

* **Blue (v1)** → current version
* **Green (v2)** → new version

Traffic is controlled using a Kubernetes Service that routes based on labels.


## Deploy

```bash
kubectl apply -f k8s/blue-green/
```
or

```bash
make blue-green
```

## Test

```bash
minikube ip
curl <IP>:30007
```

## Inspect the service details

To view detailed information about the service, run:
```bash
kubectl describe svc app-service 
```

## Switch Traffic

```bash
kubectl patch service app-service \
  -p '{"spec":{"selector":{"app":"myapp","version":"green"}}}'
```

## Validate with Load Testing (Optional)

You can use k6 to observe the traffic switch in real time:

```bash
k6 run k6/load-test.js
```

Run the test before and after switching traffic to verify that all requests are routed to the selected version.

## Result

* Instant traffic switch
* No downtime
* Easy rollback

## Delete Blue/Green resources

```bash
kubectl delete -f k8s/blue-green/
```
or

```bash
make clean-bg
```


# 🐤 Canary Deployment

## Description

A single Service routes traffic to multiple versions simultaneously.

Traffic distribution is controlled by replica count.

Example:

* 9 pods → v1
* 1 pod → v2

~10% of traffic goes to v2.


## Deploy       

```bash
kubectl apply -f k8s/canary/        
```

or

```bash
make canary
```

## Test

```bash
minikube ip
curl <IP>:30007
```

Run multiple times to observe mixed responses.


# 📊 Load Testing with k6

## Run test

```bash
k6 run k6/load-test.js
```


## Expected Results

* Majority of responses from **v1**
* Minority from **v2**

This confirms traffic distribution based on replica ratio.


## Scaling Example

```bash
kubectl scale deployment app-v2 --replicas=5
```

Re-run k6 to observe ~50/50 traffic distribution.

```bash
k6 run k6/load-test.js
```

## Delete Canary resources

```bash
kubectl delete -f k8s/canary/
```
or

```bash
make clean-canary``
```

# 🧠 Key Concepts

## Blue/Green

* Full traffic switch between environments
* Zero downtime deployments
* Fast rollback

## Canary

* Gradual traffic shift
* Lower risk releases
* Real user validation

# ⚠️ Limitations

- Traffic distribution is approximate and depends on Kubernetes load balancing
- No automatic rollback mechanism implemented
- No fine-grained traffic control (percentage-based routing)

In production, tools like Argo Rollouts or service mesh solutions would be used.

## ✅ Validation

This project was tested by recreating the environment from scratch using the provided instructions, ensuring full reproducibility.


# 🚀 Conclusion

This project demonstrates practical implementations of Blue/Green and Canary deployment strategies in Kubernetes, focusing on simplicity, clarity, and reproducibility.


## 🧹 Cleanup

To completely reset the local Kubernetes cluster:

```bash
minikube delete
```
