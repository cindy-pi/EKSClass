cp ../02-Deploy-EKS/.kube .
export KUBECONFIG=./.kube

export studentNumber=$1

export FQDN=`aws route53 list-resource-record-sets --hosted-zone-id $ZONEID --query "ResourceRecordSets[?Name == 'student${studentNumber}.wyckedsolutions.com.'].ResourceRecords[].Value" --output text`


cat <<EOF > delete-cname.json
{
  "Comment": "DELETE CNAME record for student${studentNumber}.wyckedsolutions.com",
  "Changes": [
    {
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "student${studentNumber}.wyckedsolutions.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "${FQDN}"
          }
        ]
      }
    }
  ]
}
EOF


change_id=$(aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file://delete-cname.json --query 'ChangeInfo.Id' --output text)

# Initial status is set to PENDING
status="PENDING"

# Loop until the status is no longer PENDING
while [ "$status" == "PENDING" ]; do
    echo "Waiting for the change to complete..."

    # Check the status of the change
    status=$(aws route53 get-change --id $change_id --query 'ChangeInfo.Status' --output text)

    # Wait for a short period before checking again
    sleep 10
done

cat << EOF | kubectl delete -f -
apiVersion: v1
kind: Pod
metadata:
  name: eksclass-pod-${studentNumber}
  labels:
    app: eksclass-${studentNumber}  # Add this label
spec:
  containers:
  - name: eksclass-container-${studentNumber}
    image: cindyspirion/test:test1
    ports:
    - containerPort: 7681

---

apiVersion: v1
kind: Service
metadata:
  name: eksclass-service-${studentNumber}
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 7681
      protocol: TCP
  selector:
    app: eksclass-${studentNumber}

EOF
