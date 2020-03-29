function loadkubectl() {
	if [ $commands[kubectl] ]; then 
		source <(kubectl completion zsh) 
	fi
}

function kport() {
	local pod=$(echo PODS)
	local port=$(kubectl get pod ${pod} -o json | jq '.spec.containers | .[0].ports | .[0].containerPort')
	echo "Forwarding traffic from ${pod}:${port} to localhost:${port}"
	k port-forward ${pod} ${port}:${port} | bat -l log
}

function kip() {
	local node_ip=$(kubectl get pods -l name=tiller -o wide | awk 'NR>1 {print $7}')
	local node_ports=$(kubectl get svc -o json SVC | jq -r '.spec.ports[] | "\(.name) \(.nodePort)"')
	if [[ $(echo "${node_ports}" | wc -l) -eq 1 ]]; then
		echo "${node_ports}" \
			| awk -v ip="${node_ip}" '{print "http://" ip ":"$2}' > >(cat) > >(tr -d '\n' | pbcopy)
	else
		echo "${node_ports}" \
			| awk -v OFS='\t' -v ip="${node_ip}" '{print $1, " http://" ip ":"$2}' \
			| fzf-tmux --cycle \
			| awk '{print $2}' > >(cat) > >(tr -d '\n' | pbcopy)
	fi
}

function kenv() {
	local ctx=$(kubectl config current-context)
	local cns=$(kubectl config view --minify | grep namespace: | awk 'NR>0 {print $2}')
	local server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
	echo "Context:    ${ctx}"
	echo "Namespace:  ${cns}"
	echo "Tiller:     $TILLER_NAMESPACE"
	echo "Server:     ${server}"
}

function tns() {
	local ctx=$(kubectl config current-context)
	local cns=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${ctx}\")].context.namespace}")
	echo "${cns}" >! "${HOME}/.tiller_namespace"
	export TILLER_NAMESPACE=${cns}
	echo "Switched Tiller namespace to ${cns}"
}