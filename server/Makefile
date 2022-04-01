run:
	@dune exec -w --root . ./bin/main.exe

build:
	@dune build

build/watch:
	@dune build --watch --terminal-persistence=clear-on-rebuild

setup:
	@sqlite3 db.sqlite "CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT NOT NULL); INSERT INTO users VALUES ('id', 'John');"
	@echo "Database is ready ! 🚀"