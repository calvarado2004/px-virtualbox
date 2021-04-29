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

```
