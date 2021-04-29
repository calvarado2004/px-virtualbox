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
master.example.com    Ready    control-plane,master   8m29s   v1.21.0
worker0.example.com   Ready    <none>                 6m10s   v1.21.0
worker1.example.com   Ready    <none>                 3m27s   v1.21.0
worker2.example.com   Ready    <none>                 65s     v1.21.0

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
Status: PX is operational
License: Trial (expires in 31 days)
Node ID: 5cfb0c3e-a07a-46a3-9b8d-0db92319ca30
        IP: 192.168.73.201 
        Local Storage Pool: 1 pool
        POOL    IO_PRIORITY     RAID_LEVEL      USABLE  USED    STATUS  ZONE    REGION
        0       HIGH            raid0           57 GiB  6.0 GiB Online  default default
        Local Storage Devices: 2 devices
        Device  Path            Media Type              Size            Last-Scan
        0:1     /dev/sdb2       STORAGE_MEDIUM_MAGNETIC 27 GiB          29 Apr 21 23:55 UTC
        0:2     /dev/sdc        STORAGE_MEDIUM_MAGNETIC 30 GiB          29 Apr 21 23:55 UTC
        total                   -                       57 GiB
        Cache Devices:
         * No cache devices
        Kvdb Device:
        Device Path     Size
        /dev/sdd        30 GiB
         * Internal kvdb on this node is using this dedicated kvdb device to store its data.
        Journal Device: 
        1       /dev/sdb1       STORAGE_MEDIUM_MAGNETIC
Cluster Summary
        Cluster ID: px-cluster-0276bc75-861a-4c2b-b798-3f4020bbad18
        Cluster UUID: 344d27ee-4b6d-4c2b-9f4f-daf7d53fbdc6
        Scheduler: kubernetes
        Nodes: 3 node(s) with storage (3 online)
        IP              ID                                      SchedulerNodeName       StorageNode     Used    Capacity        Status  StorageStatus   Version         Kernel              OS
        192.168.73.200  b2eaf019-d495-4c29-8a29-57a723cf5c3f    worker0.example.com     Yes             6.0 GiB 57 GiB          Online  Up              2.6.3.0-4419aa4 3.10.0-1127.el7.x86_64       CentOS Linux 7 (Core)
        192.168.73.202  6c543fc2-aeb5-4082-a20b-7046144c55b4    worker2.example.com     Yes             6.0 GiB 57 GiB          Online  Up              2.6.3.0-4419aa4 3.10.0-1127.el7.x86_64       CentOS Linux 7 (Core)
        192.168.73.201  5cfb0c3e-a07a-46a3-9b8d-0db92319ca30    worker1.example.com     Yes             6.0 GiB 57 GiB          Online  Up (This node)  2.6.3.0-4419aa4 3.10.0-1127.el7.x86_64       CentOS Linux 7 (Core)
        Warnings: 
                 WARNING: Insufficient CPU resources. Detected: 2 cores, Minimum required: 4 cores
                 WARNING: Persistent journald logging is not enabled on this node.
Global Storage Pool
        Total Used      :  18 GiB
        Total Capacity  :  171 GiB

```
# About this project

This is a derivative project from:

https://github.com/dotnwat/k8s-vagrant-libvirt 

Includes a Portworx deployment on a 3 worker node cluster and 1 master node.

It creates 3 virtual disks per worker node. Uses 6GB of RAM per node, I would recommend to have at least 32GB of RAM on your host.

Portworx pods will take up to 10 minutes to become ready.
