if [ ${commands[kubectl]} ]; then
  function kubectl() {
    source <(command kubectl completion zsh)
    command kubectl "$@"
  }
fi

# Fuzzy match a Kubernetes resource.
function kfuzz() {
  kubectl get "$1" | tfuzz 
}

# Exec into pods container.
function ke() {
  local pod=$(echo PODS)
  local container=$(kubectl get pod $pod -o json | jq '.spec.containers[].name' | tr -d '"' | tfuzz)

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

