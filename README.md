# px-virtualbox
Portworx deployed with Vagrant using Virtualbox

# Prerequisites

Install Vagrant and Virtualbox on Linux or macOS hosts\
\
-32GB RAM recommended.\
-12CPUs recommended.\
-400GB of free storage Flash storage recommended, I have 1TB on my laptop.

# Upgrade successful to CentOS 8 =)

This version has been updated to CentOS 8 but creating only one disk of 130GB per worker node, one kvdb disk of 15GB and making the root partition bigger (25GB) due to this version uses more space.

Current versions (this can change in the future), that are working:
-Kubernetes 1.21.2 
-Kernel 4.18.0-305 with kernel-devel installed
-Portworx 2.7.2

# Create the cluster

```
$ ./CreateCluster.sh
$ vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes"
NAME      STATUS   ROLES                  AGE     VERSION
master.example.com    Ready    control-plane,master   8m29s   v1.21.2
worker0.example.com   Ready    <none>                 6m10s   v1.21.2
worker1.example.com   Ready    <none>                 3m27s   v1.21.2
worker2.example.com   Ready    <none>                 65s     v1.21.2

```

#Check the Portworx Cluster

```
$ vagrant ssh master -c "sudo cat /etc/kubernetes/admin.conf" > ${HOME}/.kube/config
$ kubectl get nodes
NAME                  STATUS   ROLES                  AGE     VERSION
master.example.com    Ready    control-plane,master   15m     v1.21.2
worker0.example.com   Ready    <none>                 13m     v1.21.2
worker1.example.com   Ready    <none>                 11m     v1.21.2
worker2.example.com   Ready    <none>                 8m58s   v1.21.2
```
Check the PX pods status:

```
$ POD=$(kubectl get pods -o wide -n kube-system -l name=portworx | tail -1 | awk '{print $1}')
$ kubectl logs ${POD} -n kube-system -f
[ ctrl+c ]
$ kubectl exec -it pod/${POD} -n kube-system -- /opt/pwx/bin/pxctl status
Status: PX is operational
License: Trial (expires in 31 days)
Node ID: 84246e35-d655-44d2-a555-496fc4d62b26
        IP: 192.168.73.202 
        Local Storage Pool: 1 pool
        POOL    IO_PRIORITY     RAID_LEVEL      USABLE  USED    STATUS  ZONE    REGION
        0       MEDIUM          raid0           127 GiB 8.4 GiB Online  default default
        Local Storage Devices: 1 device
        Device  Path            Media Type              Size            Last-Scan
        0:1     /dev/sdb2       STORAGE_MEDIUM_MAGNETIC 127 GiB         25 Jun 21 01:04 UTC
        total                   -                       127 GiB
        Cache Devices:
         * No cache devices
        Kvdb Device:
        Device Path     Size
        /dev/sdc        15 GiB
         * Internal kvdb on this node is using this dedicated kvdb device to store its data.
        Journal Device: 
        1       /dev/sdb1       STORAGE_MEDIUM_MAGNETIC
Cluster Summary
        Cluster ID: px-cluster-0276bc75-861a-4c2b-b798-3f4020bbad18
        Cluster UUID: f4191c27-fdfd-4be7-997b-7a97aed8dedd
        Scheduler: kubernetes
        Nodes: 3 node(s) with storage (3 online)
        IP              ID                                      SchedulerNodeName       Auth            StorageNode     Used    Capacity        Status  StorageStatus   Version         Kernel                               OS
        192.168.73.201  ece9789f-d797-4cd6-9b89-9348c0c85c67    worker1.example.com     Disabled        Yes             8.4 GiB 127 GiB         Online  Up              2.7.2.0-1408b62 4.18.0-305.3.1.el8.x86_64    CentOS Linux 8
        192.168.73.202  84246e35-d655-44d2-a555-496fc4d62b26    worker2.example.com     Disabled        Yes             8.4 GiB 127 GiB         Online  Up (This node)  2.7.2.0-1408b62 4.18.0-305.3.1.el8.x86_64    CentOS Linux 8
        192.168.73.200  3eeb74de-5c96-4600-b0e8-870f545a6449    worker0.example.com     Disabled        Yes             8.4 GiB 127 GiB         Online  Up              2.7.2.0-1408b62 4.18.0-305.3.1.el8.x86_64    CentOS Linux 8
        Warnings: 
                 WARNING: Insufficient CPU resources. Detected: 2 cores, Minimum required: 4 cores
                 WARNING: Persistent journald logging is not enabled on this node.
Global Storage Pool
        Total Used      :  25 GiB
        Total Capacity  :  381 GiB
```
# About this project

This is a derivative project from:

https://github.com/dotnwat/k8s-vagrant-libvirt 

Includes a Portworx deployment on a 3 worker node cluster and 1 master node.

It creates 3 virtual disks per worker node. Uses 6GB of RAM per node, I would recommend to have at least 32GB of RAM on your host.

Portworx pods will take up to 10 minutes to become ready.
