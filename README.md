## Day 1
- We have created 
    - the network module where we install VPC, Networks, IGW, NGW, Route tables
    - the cluster module where we install EKS Cluster, Node group with 2 nodes, addons, permissions to access the cluster.
    - the k8s_services where we install aws-load-balancer-controller

In the **permissions.tf** we need to add permissions also for the GitHubActionsIAMRole which is assumed to deploy using github actions. It is needed to allow the **helm_release** to access the cluster, read the deployed infrastructure and compare it with the state.

## Day 2