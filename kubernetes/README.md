# Kubernetes helpers

kubectl aliases, fuzzy selectors, completions, and interactive troubleshooting
helpers. They use your existing cluster credentials and can mutate workloads.

## How-to install and inspect the target

Provision the selected tools and run `make kubernetes` from the dotfiles root.
The fuzzy helpers also need the [fzf](../fzf/README.md) shell functions,
`fzf-tmux`, tmux, and—in several cases—jq. These are not all owned by this module.

In a fresh Zsh session, use `kubectl config current-context` to inspect the
selected context without contacting the cluster. `kenv` additionally inspects
the namespace/server and queries version information.

## How-to debug a workload

Use `ke` to select a pod/container and open a shell, or `kport` to forward the
first declared container port. Verify the selection and permissions first.
`kdebug` attaches an ephemeral container using the image selected by
`KDEBUG_IMAGE` or the default in [function.zsh](function.zsh). It changes the
pod and can run privileged code according to the pod/container security context.

The separate [k8s-debug project](https://github.com/kwtucker/k8s-debug) owns the
debug image. This module does not build it or grant cluster access.

## Reference

| Helper | Effect |
| --- | --- |
| `k`, `kp`, `ks`, `kev` | kubectl and common resource/event views |
| `kfuzz TYPE` | Fuzzy-select a resource from kubectl output |
| `ke` | Execute an interactive shell in a selected container |
| `kmcron` | Create a new Job from a selected CronJob |
| `kport` | Start a localhost port forward |
| `krestart` | Restart a selected workload and watch its rollout |
| `kdebug` | Add/attach an ephemeral debug container |
| `rd-kubectl` | Use Rancher Desktop's `~/.rd/bin/kubectl` |

Global aliases such as `PODS`, `NS`, and `CTX` expand to interactive selectors;
inspect [aliases.zsh](aliases.zsh) before scripting them. Config is linked at
`$XDG_CONFIG_HOME/kubernetes`; completion lives at
`$XDG_DATA_HOME/zsh/completions/_kubectl`.

`make kubernetes.clean` removes the owned config link, module cache, and
completion—not kubeconfig files or cluster resources.

## Explanation

Short aliases remove typing, not operational risk. Resource selection, current
namespace, credentials, and permissions remain your responsibility. Use plain
kubectl with explicit selectors/context for repeatable automation.
