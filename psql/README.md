# PostgreSQL client preferences

psql prompts, query timing, output/pager defaults, and history paths. This module
does not install PostgreSQL or create a database cluster; its tool ownership is
intentionally empty.

## How-to apply client settings

Install a PostgreSQL client through a suitable platform/project tool manager.
Run `make psql` from the dotfiles root, open a fresh Zsh session, and inspect
`psql --version`. Connecting to a server is a separate authenticated action.

**Keep passwords outside this checkout.** The current `PGPASSFILE` default points
at `$XDG_CONFIG_HOME/psql/pgpass`, inside the linked repository directory. Before
storing credentials, override it in ignored `zsh/local`, for example:

```sh
export PGPASSFILE="$HOME/.pgpass"
```

Protect that external password file with the permissions required by PostgreSQL;
never add it to this repository.

## Reference

- `PSQLRC`: `$XDG_CONFIG_HOME/psql/psqlrc`.
- `PSQL_HISTORY`: `$XDG_CACHE_HOME/psql/psql_history`.
- [psqlrc](psqlrc): timing, verbose errors, automatic expanded output, and `less -SX`.
- `setupPostgres` in [functions.zsh](functions.zsh): legacy local-server setup
  using sudo and `/usr/local/var/postgres`. It is machine-specific and mutating;
  do not treat it as a portable installer or diagnostic.
- `make psql.clean`: remove owned config/module cache. This deletes the configured
  history cache; it does not delete database data or server accounts.

## Explanation

Client presentation, authentication files, and server administration are
different concerns. Zsh exports do not configure Bash or already-running
clients. Use your database provider's setup workflow for server lifecycle.
