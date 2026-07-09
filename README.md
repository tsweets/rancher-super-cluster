#### My Dev Environment (Yours will be different)
|Host|IP|
| --- | --- |
|pve2.t.s.com|10.107.0.22|
|rancher||
|Cluster A VIP||
|Cluster A Node 1||
|Cluster A Node 2||
|Cluster A Node 3||
|Cluster B VIP||
|Cluster B Node 1||
|Cluster B Node 2||
|Cluster C VIP||
|Cluster C Node 1||
|Cluster C Node 2||
|Cluster C Node 3||

#### Directory Structure
```
rancher-automation-project/
├── README.md
├── deploy.sh                      # The master orchestrator script
│
├── tofu/                          # --- OPENTOFU LAYER ---
│   ├── stage1-proxmox/            # Stage 1: Spin up the 10+ bare Rocky 8 VMs
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf             # Outputs VM IPs for your Ansible inventory
│   │   ├── providers.tf
│   │   ├── terraform.tfvars.example  # Example configuration with secrets
│   │   └── terraform.tfvars       # Your local configuration (ignored by git)
│   │
│   └── stage2-rancher/            # Stage 2: Post-RKE2 Rancher bootstrap & cluster join
│       ├── main.tf                # Deploys Rancher Helm chart & configures provider
│       ├── variables.tf
│       └── providers.tf
│
└── ansible/                       # --- ANSIBLE LAYER ---
    ├── ansible.cfg
    ├── requirements.yml           # Defines rancherfederal.rke2 collection dependency
    ├── inventory/
    │   └── hosts.yaml             # Target nodes mapped out by cluster groups
    │
    ├── group_vars/                # Cluster-specific settings (tokens, network pools)
    │   ├── all.yaml
    │   ├── rancher_management.yaml
    │   ├── downstream_cluster_01.yaml
    │   ├── downstream_cluster_02.yaml
    │   └── downstream_cluster_03.yaml
    │
    └── playbooks/
        ├── site.yaml              # Master playbook importing the playbooks below
        ├── 01_os_prep.yaml        # Disables firewalld (or tweaks it), sets up storage
        └── 02_rke2_install.yaml   # Invokes the rancherfederal.rke2 role
```

#### Usage Instructions

1. **Prepare Proxmox Environment**:
   - Ensure you have a Rocky Linux 8 cloud-init template named `rocky8-cloudinit-base`
   - Configure your Proxmox API access with appropriate permissions

2. **Configure Variables**:
   - Copy the example file: `cp tofu/stage1-proxmox/terraform.tfvars.example tofu/stage1-proxmox/terraform.tfvars`
   - Edit `tofu/stage1-proxmox/terraform.tfvars` to set:
     - Proxmox host details
     - SSH key path
     - VM naming and IP ranges
     - Resource allocation (memory, cores, disk)
   - **Important**: Never commit your `terraform.tfvars` file to version control as it contains sensitive information

3. **Deploy VMs**:
   ```bash
   cd tofu/stage1-proxmox
   tofu init
   tofu apply -auto-approve
   ```

4. **Output**:
   The deployment will output:
   - VM names: `rancher-node-01` through `rancher-node-10`
   - VM IPs: 10.107.0.101 through 10.107.0.110
   - VM IDs: 100 through 109

5. **Next Steps**:
   - The Ansible inventory will be updated to use these IPs for RKE2 installation
   - Run `deploy.sh` to continue with the full Rancher deployment process

#### Security Best Practices

- All sensitive information (passwords, API keys) is stored in `terraform.tfvars`
- The `.gitignore` file ensures that `terraform.tfvars` and other sensitive files are never committed to version control
- The example configuration file `terraform.tfvars.example` shows the required structure without exposing secrets