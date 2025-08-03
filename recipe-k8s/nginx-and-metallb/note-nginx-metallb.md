# DEPLOIEMENT DE METALLB
## kubectl create -f metallb-native.yaml 
## kubectl apply -f ip_address_pool/ipaddresspool.yml

# DEPLOIEMENT DE INGRESS NGINX
## kubectl create -f ingress-nginx.yaml 


########################

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
kubectl get all -n metallb-system
kubectl apply -f ip_address_pool/ipaddresspool.yml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/cloud/deploy.yaml
