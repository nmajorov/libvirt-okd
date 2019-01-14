#!/usr/bin/env ruby

# @author Nikolaj Majorov
# create Ansible inventory
# dynamically from vagrant file

# example of ssh-config
#Host jira-server
 # HostName 127.0.0.1
 # User vagrant
 # Port 2222
 # UserKnownHostsFile /dev/null
 # StrictHostKeyChecking no
 # PasswordAuthentication no
 # IdentityFile /home/nmajorov/workspace/ansible-jira/.vagrant/machines/jira-server/virtualbox/private_key
 # IdentitiesOnly yes
 # LogLevel FATAL

#require 'json' 

require 'stringio'

$inventory = StringIO.new

$inventory << "\n[OKD]\n"


# define one host
def define_host(host)

    

    cmd = `vagrant ssh-config #{host}`

    cmd.each_line do |line|

        if line.strip.start_with?("Host") && !line.strip.start_with?("HostName")
            #puts "find host #{line}"
            $inventory << "\n" + line.strip.slice(5..line.size)
            

        end 


        if /HostName/.match(line)
            $inventory << " ansible_ssh_host=" + line.scan(/[^HostName\s].+/)[0] + " \n"
        end 

       
    end
  
    

end

#puts ({"okd" => inventory})

def list_host

    cmd_list=`vagrant status`

    cmd_list.each_line do |line|                                                                                                                                                                                            
        if /running/.match(line)
            arr = line.scan(/(.*)running \(libvirt\)/).first
            host = arr.fetch(0).strip
            
            #puts "find running host #{host}\n"  
            define_host host                                                                                                                                                                                
        end 
    end    
end 


list_host


vars =<<-FOO
\n \n[OKD:vars]
ansible_ssh_user=vagrant
ansible_ssh_private_key_file=./id_key
ansible_ssh_extra_args="-o IdentitiesOnly=yes"
FOO

$inventory << vars

puts "#{$inventory.string}"
