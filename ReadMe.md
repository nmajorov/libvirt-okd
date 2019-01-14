
# OKD 3.11 installation on vagrant-libvirt 


1. define custom libvirt network first with command


          
            virsh net-define --file okd-network.libvirt 
            virsh net-list  --all
            virsh net-start okd 
            virsh net-list 


2. run vagrant


    vagrant up


3. repare servers and bastion
 

           ansible-playbook -i hosts --tags okd site.yaml 


4. login to bastion and run in vagrant home dir installation


        ansible-playbook openshift-ansible/playbooks/prerequisites.yml
        
        ansible-playbook openshift-ansible/playbooks/deploy_cluster.yml


5. login okd 3.11  using url:


        https://okd-master0.niko.io:8443/




## Additionals DNS config on host

Domain niko.io is already defined in okd-network.libvirt

Create file:

        /etc/NetworkManager/dnsmasq.d/openshift.conf


with content:


            server=/niko.io/192.168.121.1

            address=/.apps.niko.io/192.168.121.126

            dns-forward-max=400


change NetworkManager configuration:

            [main]
            dns=dnsmasq

restart NetworkManager


add dns to firewalld:


        sudo firewall-cmd --add-service=dns


list zones:


            sudo firewall-cmd --zone=public --list-all 
            public (active)
            target: default
            icmp-block-inversion: no
            interfaces: wlp4s0
            sources: 
            services: dhcpv6-client dns mdns ssh
            ports: 
            protocols: 
            masquerade: no
            forward-ports: 
            source-ports: 
            icmp-blocks: 
            rich rules: 
