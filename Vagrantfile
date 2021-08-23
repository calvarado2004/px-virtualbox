# number of worker nodes
NUM_WORKERS = 3
# number of extra disks per worker
NUM_DISKS = 1
# size of each disk in gigabytes
DISK_GBS = 143

ENV["VAGRANT_EXPERIMENTAL"] = "disks"

MASTER_IP = "192.168.73.100"
WORKER_IP_BASE = "192.168.73.2" # 200, 201, ...
TOKEN = "yi6muo.4ytkfl3l6vl8zfpk"

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |v|
    v.memory = 6144
    v.cpus = 2
    v.check_guest_additions = false
    v.gui = false
    v.customize ["modifyvm", :id, "--audio", "none"]
  end

  config.vm.provision "shell", path: "common.sh"
  config.vm.provision "shell", path: "local-storage/create-volumes.sh"
  config.vm.disk :disk, size: "25GB", primary: true
  
  config.vm.define "master" do |master|
    master.vm.hostname = "master.example.com"

    master.vm.network "private_network", ip: MASTER_IP

    master.vm.provision :file do |file|
      file.source = "kube-flannel.yml"
      file.destination = "/tmp/kube-flannel.yml"
    end

    master.vm.provision "shell", path: "master.sh",
      env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }

    master.vm.provision :file do |file|
      file.source = "local-storage/storageclass.yaml"
      file.destination = "/tmp/local-storage-storageclass.yaml"
    end
    master.vm.provision :file do |file|
      file.source = "local-storage/provisioner.yaml"
      file.destination = "/tmp/local-storage-provisioner.yaml"
    end
    master.vm.provision "shell", path: "local-storage/install.sh"
   
    master.vm.provision :file do |file|
      file.source = "portworx-enterprise.yaml"
      file.destination = "/tmp/portworx-enterprise.yaml"
    end



    master.vm.provision "shell", path: "portworx.sh"
  end

  (0..NUM_WORKERS-1).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.hostname = "worker#{i}.example.com"

      worker.vm.network "private_network", ip: "#{WORKER_IP_BASE}" + i.to_s.rjust(2, '0')
      (1..NUM_DISKS).each do |j|
        worker.vm.disk :disk, size: "#{DISK_GBS}GB", name: "worker#{i}-disk#{j}"
        worker.vm.disk :disk, size: "40GB", name: "worker#{i}-disk-kvdb"
      end

      worker.vm.provision "shell", path: "worker.sh",
        env: { "MASTER_IP" => MASTER_IP, "TOKEN" => TOKEN }
    end
  end

end
