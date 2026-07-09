#!/usr/bin/env bash
set -euo pipefail

echo "====== [PHASE 1] Provisioning Rocky 8 VMs on Proxmox PVE 9 ======"
cd tofu/stage1-proxmox
tofu init
tofu apply -auto-approve
cd ../../

echo "====== [PHASE 2] Preparing OS and Installing RKE2 Clusters ======"
cd ansible
ansible-galaxy collection install -r requirements.yml
# (Optional: Use a script to parse tofu outputs directly into inventory/hosts.yaml here)
ansible-playbook playbooks/site.yaml -i inventory/hosts.yaml
cd ../

echo "====== [PHASE 3] Bootstrapping Rancher and Attaching Clusters ======"
cd tofu/stage2-rancher
tofu init
tofu apply -auto-approve

echo "=================================================================="
echo " SUCCESS: Rancher and 3 downstream clusters are fully operational!"
echo "=================================================================="