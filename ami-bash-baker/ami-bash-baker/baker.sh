INSTANCE_LIST="instance_list.txt"
INSTANCES=$(cat $INSTANCE_LIST)
DATE_STAMP=$(date +'%Y-%m-%d')


for INSTANCE in $INSTANCES;
do
    INSTANCE_NAME=$(aws ec2 describe-instances --instance-ids $INSTANCE --query \
    'Reservations[*].Instances[*].Tags[?Key==`Name`].Value[]' --output text)
    echo "Instance name is" $INSTANCE_NAME
    AMI_ID=$(aws ec2 describe-instances --instance-ids $INSTANCE --query \
    'Reservations[*].Instances[*].ImageId' --output text)
    echo "Current AMI ID is" $AMI_ID
    NEW_AMI_VERSION=$(expr $(aws ec2 describe-images --image-ids $AMI_ID --query \
    'Images[*].Tags[?Key==`Version`].Value[]' --output text) + 1)
    echo "New AMI version will be" $NEW_AMI_VERSION
    
    NEW_AMI_ID=$(aws ec2 create-image --instance-id $INSTANCE --name $INSTANCE_NAME-$DATE_STAMP"-ami" --no-reboot --output text)
    echo "New AMI ID will be" $NEW_AMI_ID
    CREATE_TAG=$(aws ec2 create-tags --resources $NEW_AMI_ID --tags Key=Version,Value=$NEW_AMI_VERSION)
    CREATE_TAG=$(aws ec2 create-tags --resources $NEW_AMI_ID --tags Key=Name,Value=$INSTANCE_NAME-$DATE_STAMP"-ami")
    
    echo "Created a new AMI for" $INSTANCE_NAME "with name" $INSTANCE_NAME-$DATE_STAMP"-ami" "and ID" $NEW_AMI_ID "running as Version:" $NEW_AMI_VERSION
done

#To-do: If "Version" tag does not exist, create one and append Value '1'
#To-do: Catch non-compatiable instance names and replace character
