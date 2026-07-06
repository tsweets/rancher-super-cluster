### Create Cloud Init Image for PVE 9
```
# Download Rocky 8 Generic Cloud image
wget https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2

# Create VM Shell
qm create 8000 --name "rocky8-cloudinit-base" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

# Import disk and set config
qm importdisk 8000 Rocky-8-GenericCloud-Base.latest.x86_64.qcow2 local-lvm
qm set 8000 --scsi0 local-lvm:vm-8000-disk-0
qm set 8000 --ide2 local-lvm:cloudinit
qm set 8000 --boot order=scsi0
qm set 8000 --serial0 socket --vga serial0

# Pro Tip for Ansible: Pre-enable the QEMU Guest Agent so Proxmox tracks the IPs
qm set 8000 --agent enabled=1

# Turn it into a template
qm template 8000
```
