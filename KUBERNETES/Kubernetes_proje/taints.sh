#/bash/bin

node1=$(kubectl get no -o jsonpath="{.items[1].metadata.name}")

node2=$(kubectl get no -o jsonpath="{.items[2].metadata.name}")

node3=$(kubectl get no -o jsonpath="{.items[3].metadata.name}")

kubectl taint node $node1 tier=production:NoSchedule

kubectl taint node $node2 tier=production:NoSchedule

kubectl taint node $node3 tier=production:NoSchedule

kubectl label node $node1 tier=production

kubectl label node $node2 tier=production

kubectl label node $node3 tier=production1
