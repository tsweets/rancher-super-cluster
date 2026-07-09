output "vm_names" {
  description = "Names of the created VMs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

output "vm_ips" {
  description = "IP addresses of the created VMs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.network_interface.0.ip_address]
}

output "vm_ids" {
  description = "IDs of the created VMs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.id]
}