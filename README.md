# px-virtualbox
Portworx deployed with Vagrant using Virtualbox

# Prerequisites

Install Vagrant and Virtualbox on Linux or macOS hosts\
\
-32GB RAM recommended.\
-12CPUs recommended.\
-100GB of free storage Flash storage recommended.

# Create the cluster

```
$ ./CreateCluster.sh
$ vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes"
NAME      STATUS   ROLES                  AGE     VERSION
master    Ready    control-plane,master   8m29s   v1.21.0
worker0   Ready    <none>                 6m10s   v1.21.0
worker1   Ready    <none>                 3m27s   v1.21.0
worker2   Ready    <none>                 65s     v1.21.0

```

#Check the Portworx Cluster

```
$ vagrant ssh master -c "sudo cat /etc/kubernetes/admin.conf" > ${HOME}/.kube/config
$ kubectl get nodes
NAME                  STATUS   ROLES                  AGE     VERSION
master.example.com    Ready    control-plane,master   15m     v1.21.0
worker0.example.com   Ready    <none>                 13m     v1.21.0
worker1.example.com   Ready    <none>                 11m     v1.21.0
worker2.example.com   Ready    <none>                 8m58s   v1.21.0
```
Check the PX pods status:

```
$ POD=$(kubectl get pods -o wide -n kube-system -l name=portworx | tail -1 | awk '{print $1}')
$ kubectl logs ${POD} -n kube-system -f
[ ctrl+c ]
$ kubectl exec -it pod/${POD} -n kube-system -- /opt/pwx/bin/pxctl status
```
# About this project

This is a derivative project from:

https://github.com/dotnwat/k8s-vagrant-libvirt 

Includes a Portworx deployment on a 3 worker node cluster and 1 master node.

It creates 3 virtual disks per worker node. Uses 6GB of RAM per node, I would recommend to have at least 32GB of RAM on your host.

Portworx pods will take up to 10 minutes to become ready.
