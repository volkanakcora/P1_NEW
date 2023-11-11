kubectl cluster-info: 'get the cluster info'

kubectl get nodes: 'get the node informations'

kuebctl config: ' get config informations'

kubectl "cmd like cp" -- help: tells you hwo to use the command

kubectl delete pods testpod: delete the testpod 

kubectl get ns: brings the namespaces

kubectl get pods -n kube-system: brings the pods in the namespaces

kubectl get pods -A: brings all pods in every ns you can use it with -o (wide|yaml|json)

OR

kubectl get pods -A -o json | jq -r ".items[].spec.containers[].name"

kubectl explain pod: gives you the how to use it




