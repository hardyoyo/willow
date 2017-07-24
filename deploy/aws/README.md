# AWS ECS Willow deployment

1. If not logged in:

    ```
    ./gen-login.sh  # generates login.sh
    ./login.sh  # contains private secrets for your AWS account
    ```
1. Create ECRs by hand. See `build-and-push.sh` for the necessary ECRs. The CloudFormation template also has them.
1. Make sure ECS is fully set up on the AWS account (special role is created, you're happy with the VPC, networking and security group setup).
1. Create the willow cluster. Use the command from `scratch.sh` for `create-cluster` if you like.
1. Create some EC2 instances which can run the ECS containers. Make sure the instances are showing up under the cluster in ECS.
1. `./build-and-push.sh`
1. run the commands to create a service and register a task definition in scratch.sh in that order, manually, ensuring each one succeeds. Check their results via the aws cli or web console.
1. Willow should be running on ECS.

TODOs (this is just indicative - actual list worked on tracked by Willow project management):

- [ ] Finish CloudFormation template
- [ ] Integrate RDS. `db` container already removed from CloudFormation and taskdef.json, but RDS definition not yet added.

    How will containers know they need to wait on RDS before they start? CloudFormation supposed to be able to specify dependencies.

- [ ] Integrate an ELB in front
- [ ] Add nginx for serving static assets.