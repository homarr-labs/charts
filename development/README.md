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
kubectl create secret generic db-encryption \
--from-literal=db-encryption-key='d4d0dd977c9795b988e68f115f444c40334a63a391cfb9b3a0857d2d77deff03'  \
--namespace homarr
```

```bash
kubectl create secret generic db-secret \
--from-literal=db-url='mysql://homarr:your-db-password@homarr-mysql:3306/homarrdb' \
--namespace homarr
```

## Install the chart

### Use local docker image

#### Internal Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=internal-db/override-internal-db-local-docker-img.yaml
```

#### Mysql Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=mysql-db/override-mysql-db-local-docker-img.yaml
```

#### Postgresql Database

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=postgresql-db/override-pg-db-local-docker-img.yaml
```

### Use github docker image

```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=internal-db/override-internal-db.yaml
```

#### Mysql Database
```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=mysql-db/override-mysql-db.yaml
```

#### Postgresql Database
```bash
helm install homarr ../charts/homarr/homarr-1.0.0.tgz --namespace homarr --values=postgresql-db/override-pg-db.yaml
```

## Port forwarding Homarr
If you are using kind with the script provided you can access to homarr using Node port 30000 http://localhost:30000 if not you can port forward the service using the command bellow


```bash
kubectl port-forward service/homarr 3000:3000 --namespace homarr
```
