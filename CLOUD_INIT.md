### Create Cloud Init Image for PVE 9
```
# Download Rocky 8 Generic Cloud image
wget https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2

# Create VM Shell
qm create 9001 --name "rocky8-cloudinit-base" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

# Import disk and set config
qm importdisk 9001 Rocky-8-GenericCloud-Base.latest.x86_64.qcow2 Fast-DATA
qm set 9001 --scsi0 Fast-DATA:vm-9001-disk-0
qm set 9001 --ide2 Fast-DATA:cloudinit
qm set 9001 --boot order=scsi0
qm set 9001 --serial0 socket --vga serial0

# Pro Tip for Ansible: Pre-enable the QEMU Guest Agent so Proxmox tracks the IPs
qm set 9001 --agent enabled=1

# Turn it into a template
qm template 9001
```
