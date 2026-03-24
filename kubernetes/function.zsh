# Fuzzy match a Kubernetes resource.
# Usage: kfuzz <resource-type>  e.g. kfuzz pods, kfuzz deploy
function kfuzz() {
  kubectl get "$1" | tfuzz
}

# Debug into a pod using your dev image as an ephemeral sidecar.
# Fuzzy selects the pod then the target container. The debug container
# is completely isolated — exits cleanly and leaves nothing on the cluster.
function kdebug() {
  local pod=$(echo PODS)
  local container=$(kubectl get pod $pod -o json | jq '.spec.containers[].name' | tr -d '"' | tfuzz)

  echo "Attaching debug container to ${pod}:${container}..."
  kubectl debug -it $pod \
    --image=ghcr.io/kwtucker/dotfiles-devenv:latest \
    --target=$container \
    -- zsh
}

# Exec into a running pod's container.
# Fuzzy selects the pod then the container. Prefers zsh, falls back to bash.
function ke() {
  local pod=$(echo PODS)
  local container=$(kubectl get pod $pod -o json | jq '.spec.containers[].name' | tr -d '"' | tfuzz)
  echo "In $pod:$container"
  kubectl exec $pod -c $container -it -- sh -c 'which zsh && exec zsh || exec bash'
}

# Manually trigger a job from an existing cronjob.
# Fuzzy selects the cronjob and creates a uniquely named job from it.
function kmcron() {
  local cron=$(echo CRONS)
  local job=${cron}-manual-$(date +%s)

  echo "Creating Job from cron job ${cron} with name ${job}"
  kubectl create job $job --from=cronjob/${cron}
}

# Forward a pod's first container port to the same port on localhost.
# Fuzzy selects the pod and reads the port from the pod spec automatically.
function kport() {
  local pod=$(echo PODS)
  local port=$(kubectl get pod ${pod} -o json | jq '.spec.containers | .[0].ports | .[0].containerPort')
  echo "Forwarding traffic from ${pod}:${port} to localhost:${port}"
  kubectl port-forward ${pod} ${port}:${port}
}

# Print a summary of the current kubectl context, namespace, and server.
# Useful for confirming which cluster and namespace you are operating in.
function kenv() {
  local ctx=$(kubectl config current-context)
  local cns=$(kubectl config view --minify | grep namespace: | awk 'NR>0 {print $2}')
  local server=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
  echo "Context:   ${ctx}"
  echo "Namespace: ${cns}"
  echo "Server:    ${server}"
  kubectl version --output=yaml 2>/dev/null | grep -E 'gitVersion|platform'
}

# Restart a workload (deployment, statefulset, or daemonset) and watch the rollout until complete.
function krestart() {
  local resource_type=$(echo -e "deployment\nstatefulset\ndaemonset" | fzf-tmux --reverse --prompt="resource type> ")
  [[ -z "$resource_type" ]] && return 1
  local resource=$(kfuzz $resource_type)
  [[ -z "$resource" ]] && return 1
  echo "Restarting $resource_type/$resource..."
  kubectl rollout restart $resource_type/$resource
  kubectl rollout status $resource_type/$resource
}
