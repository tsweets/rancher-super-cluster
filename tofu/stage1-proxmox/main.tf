# Configure the Proxmox provider
provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_host}:8006/api2/json"
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

# Create multiple VMs using the vm_config variable
resource "proxmox_vm_qemu" "vm" {
  count = var.vm_count

  name        = var.vm_config[count.index].name
  target_node = "pve2.t.s.com"  # Change this to your actual node name
  
  # Use the template VM that was created earlier
  clone       = var.vm_template
  
  # VM specifications
  memory      = var.vm_memory
  cores       = var.vm_cores
  sockets     = 1
  
  # Disk configuration
  disk {
    slot    = 0
    size    = var.vm_disk_size
  }
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  
  # Cloud-init configuration (if using cloud-init)
  ipconfig0 = "ip=${var.vm_config[count.index].ip}/24,gw=10.107.0.1"
  
  # SSH key for access
  sshkeys = file(var.ssh_key_path)
  
  # Other settings
  agent = 1  # Enable QEMU guest agent
  
  # VM ID (unique per VM)
  id = var.vm_start + count.index
  
  # Ensure the VM is started after creation
  oncreate = true
}