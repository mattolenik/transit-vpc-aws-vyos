VYOS_VERSION  ?= 1.1.8
BUILDER_AMI   ?= ami-51537029
VPC_ID        ?= vpc-0d340491244c06d1a
SUBNET_ID     ?= subnet-0db16f6133bda5b0c
AWS_REGION    ?= us-west-2

all: packer update-ami

packer:
	time packer build \
		-var vyos_version="$(VYOS_VERSION)" \
		-var builder_ami="$(BUILDER_AMI)" \
		-var vpc_id="$(VPC_ID)" \
		-var subnet_id="$(SUBNET_ID)" \
		-var ami_users="$(AMI_USERS)" \
		-var aws_region="$(AWS_REGION)" \
		-force vyos.json

update-ami: packer
	ami_id=$$(cat out/manifest.json | jq -r '.builds[].artifact_id' | awk -F: '{print $$2}'); \
	echo $$ami_id

.PHONY: packer update-ami
