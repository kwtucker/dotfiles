function docker_prune() {
	docker system prune --volumes -fa
}
