#!/bin/bash -e

#Variables
regionid=us-west-2
profile=default
tag_name=LT-Group


# DO NOT EDIT ANY THING BELOW WITHOUT DEVOPS APPROVAL
 tagvalue=""
 instid=""

 echo "=> Fetching All EC2 Instances"
 instarr=( $(aws ec2 describe-instances --profile ${profile} --region ${regionid} --query 'Reservations[*].Instances[*].{ID:InstanceId}' --output text) )
 echo "=> Loop through all the EC2 Instances Found"
 for instid in "${instarr[@]}"
 do
 printf "\n"
 echo "=> Querying instance-id: " ${instid} "for tag value"
 tagvalue=`aws ec2 describe-tags --profile ${profile} --region ${regionid} --filters "Name=resource-id,Values=${instid}" "Name=key,Values=${tag_name}" --query Tags[].{Value:Value} --output text`
 echo "=> Fetching All EC2 Instances Attached to the Instance ${instid}"
 volidarr=( $(aws ec2 describe-volumes --profile ${profile} --region ${regionid} --filters Name=attachment.instance-id,Values=${instid} --query 'Volumes[*].Attachments[*].{volid:VolumeId}' --output text) )
 echo "=> Loop through all the EC2 Instances Found"
  for volid in ${volidarr[@]}
    do
    echo "Adding tag ${tag_name} with value ${tagvalue} to volume-id: " ${volid}
    aws ec2 create-tags --profile ${profile} --region ${regionid} --resources ${volid} --tags Key=${tag_name},Value="${tagvalue}"
    echo "Done!"
    done
 done
