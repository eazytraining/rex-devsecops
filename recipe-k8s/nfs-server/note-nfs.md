# DEPLOIEMENT DU NFS SERVER
## kubectl create -f deployment.yaml 
### kubectl create -f rbac.yaml
#### kubectl create -f class.yaml
##### kubectl -n storage exec -t -i $(kubectl -n storage get pod -l app=nfs-provisioner -o jsonpath="{.items[0].metadata.name}") -- ls /exports/
######

########################

nfs_base_url=https://raw.githubusercontent.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner/nfs-server-provisioner-1.8.0/deploy/kubernetes 

kubectl create -f ${nfs_base_url}/deployment.yaml
kubectl create -f ${nfs_base_url}/rbac.yaml
kubectl create -f ${nfs_base_url}/class.yaml