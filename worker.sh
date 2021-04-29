#!/bin/bash
set -e

kubeadm join master.example.com:6443 --token ${TOKEN} \
  --discovery-token-unsafe-skip-ca-verification
