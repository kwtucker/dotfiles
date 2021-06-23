setupPostgres() {
	initdb -D /usr/local/var/postgres
	createuser -d postgres
}
