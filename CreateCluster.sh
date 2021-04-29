
export VAGRANT_EXPERIMENTAL="disks"

vagrant up --provider=virtualbox

sleep 60s

vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes"

echo Lets wait for all the nodes to become available. Sleeping for 60 seconds...

sleep 60s

echo Continue...

vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f /tmp/portworx-enterprise.yaml"

vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes"

sleep 60s

vagrant ssh master -c "sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get pods -o wide -n kube-system -l name=portworx"
