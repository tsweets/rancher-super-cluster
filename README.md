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
│   │   └── providers.tf
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
