setupPostgres() {
	sudo mkdir -p /usr/local/var/postgres
	sudo chmod 775 /usr/local/var/postgres
	sudo chown $(whoami) /usr/local/var/postgres
	initdb -D /usr/local/var/postgres
	createuser -d postgres
}
