echo -e "\n\n\t#################### Show target EC2 before action ####################\n\n"
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters \
    "Name=tag:Project,Values=${1}" \
    "Name=instance-state-name,Values=running,stopped" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --query 'Reservations[].Instances[].{Id:InstanceId,State:State.Name,Subnet:SubnetId,PrivateIP:PrivateIpAddress}' \
    --output table

echo -e "\n\n\t#################### Stop EC2 ####################\n\n"
aws ec2 stop-instances \
    --instance-ids "${INSTANCE_ID}"

echo -e "\n\n\t#################### Verify final EC2 state ####################\n\n"
aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --query 'Reservations[].Instances[].{Id:InstanceId,State:State.Name}' \
    --output table
