variable "proxmox_host" {
  description = "The hostname or IP address of the Proxmox server"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox API user (e.g., root@pam)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
}

variable "ssh_key_path" {
  description = "Path to SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 10
}

variable "vm_template" {
  description = "Template VM name to clone from"
  type        = string
  default     = "rocky8-cloudinit-base"
}

variable "vm_memory" {
  description = "Memory allocation for each VM (MB)"
  type        = number
  default     = 2048
}

variable "vm_cores" {
  description = "Number of CPU cores for each VM"
  type        = number
  default     = 2
}

variable "vm_network" {
  description = "Network interface configuration"
  type        = string
  default     = "virtio,bridge=vmbr0"
}

variable "vm_disk_size" {
  description = "Disk size for each VM (GB)"
  type        = number
  default     = 20
}

variable "vm_start" {
  description = "Starting number for VM IDs and naming"
  type        = number
  default     = 100
}

variable "vm_config" {
  description = "Configuration for VMs including names and IPs"
  type = list(object({
    name = string
    ip   = string
  }))
  default = [
    { name = "rancher-node-01", ip = "10.107.0.101" },
    { name = "rancher-node-02", ip = "10.107.0.102" },
    { name = "rancher-node-03", ip = "10.107.0.103" },
    { name = "rancher-node-04", ip = "10.107.0.104" },
    { name = "rancher-node-05", ip = "10.107.0.105" },
    { name = "rancher-node-06", ip = "10.107.0.106" },
    { name = "rancher-node-07", ip = "10.107.0.107" },
    { name = "rancher-node-08", ip = "10.107.0.108" },
    { name = "rancher-node-09", ip = "10.107.0.109" },
    { name = "rancher-node-10", ip = "10.107.0.110" }
  ]
}