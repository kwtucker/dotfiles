if [ $commands[kubectl] ]; then
  function kubectl() {
    source <(command kubectl completion zsh)
    command kubectl "$@"
  }
fi

# Fuzzy match a Kubernetes resource.
function kfuzz() {
  kubectl get "$1" | FZF
}

# Exec into pods container.
function ke() {
  local pod=$(echo PODS)
  local container=$(kubectl get pod $pod -o json | jq '.spec.containers[].name' | tr -d '"' | sort -fd | FZF )

  echo "In $pod:$container"
  kubectl exec $pod -c $container -it -- bash  
}

# Manually create job from cronjob.
function kmcron() {
  local cron=$(echo CRONS)
  local job=${cron}-manual-$(date +%s)

  echo "Creating Job from cron job ${cron} with name ${job}"
  kubectl create job $job --from=cronjob/${cron} 
}

function kport() {
	local pod=$(echo PODS)
	local port=$(kubectl get pod ${pod} -o json | jq '.spec.containers | .[0].ports | .[0].containerPort')
	echo "Forwarding traffic from ${pod}:${port} to localhost:${port}"
	kubectl port-forward ${pod} ${port}:${port} | bat -l log
}

function kip() {
	local pod=$(kubectl get pod PODS | awk 'NR>1 {print $1}')
	local node_ip=$(kubectl get pod $pod -o custom-columns=IP:.spec.nodeName | awk 'NR>1 {print $1}')
	local serviceName=$(kubectl get pod $pod -o custom-columns=NAME:.spec.containers[0].name | awk 'NR>1 {print $1}')
	local node_ports=$(kubectl get svc -o json ${serviceName} | jq -r '.spec.ports[] | "\(.name) \(.nodePort)"')

	if [[ $(echo "${node_ports}" | awk '{print $2}') -eq null ]]; then
		echo "no port for ${pod} pod. Try another one"
		return
	fi

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
  local versions=$(kubectl version --short=true)
  echo "Context:        ${ctx}"
  echo "Namespace:      ${cns}"
  echo "${versions}"
  echo "Server URL:     ${server}"
}

