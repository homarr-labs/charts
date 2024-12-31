# Homarr Helm chart

## Create a cluster using kind

### OPTION 1 : Using a local docker image

1. run the script `kind-with-registry.sh` to create a local cluster and local registry
   https://kind.sigs.k8s.io/docs/user/local-registry/

2. build and push local homarr image

```bash
docker build -t localhost:5001/homarr:1.0 .
```

```bash
docker push localhost:5001/homarr:1.0
```

### OPTION 2 : Using existing docker image from github registry

1. Create a local cluster using kind
```bash
kind create cluster --name homarr --image kindest/node:v1.29.0
```

## Package the chart

Under `charts/homarr`

```bash
helm dependency build
```

Package the chart :

```bash
../hack/helm-package.sh
```

## Create homarr namespace

```bash
kubectl create namespace homarr
```

## Create homarr secrets

```bash
kubectl create secret generic auth-credentials-secret \
--from-literal=auth-secret='mAxnWLFaQE59MauTrCTm5sUq5xf3sdG5m0eKnp2e3OU' \
--namespace homarr
```

```bash
kubectl create secret generic db-secret \
--from-literal=db-encryption-key='d4d0dd977c9795b988e68f115f444c40334a63a391cfb9b3a0857d2d77deff03'  \
--from-literal=db-url='mysql://homarr:your-db-password@homarr-mysql:3306/homarrdb' \
--from-literal=mysql-root-password='your-db-password' \
--from-literal=mysql-password='your-db-password' \
--namespace homarr
```

## Install the chart

### Use local docker image

#### Internal Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=internal-db/override-internal-db-local-docker-img.yaml
```

#### External Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=external-db/override-external-db-local-docker-img.yaml
```

### Use github docker image

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=internal-db/override-internal-db.yaml
```

#### External Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=external-db/override-external-db.yaml
```

## Port forwarding Homarr
If you are using kind with the script provided you can access to homarr using Node port 30000 http://localhost:30000 if not you can port forward the service using the command bellow


```bash
kubectl port-forward service/homarr 3000:3000 --namespace homarr
```
