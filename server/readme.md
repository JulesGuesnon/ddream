# Ddream server

This server showcase [Dream](https://github.com/aantron/dream) a nice library to make http server with Ocaml, and how to make authentication with [Ethereum signed message](https://medium.com/mycrypto/the-magic-of-digital-signatures-on-ethereum-98fe184dc9c7) and [Graphql](https://graphql.org/).

## :fire: Requirements

-   :camel: [Opam](https://opam.ocaml.org/doc/Install.html)

## :gear: Setup

### Create a switch

A switch will allow to sandbox a project for a specific version of Ocaml. Then we setup our terminal by injecting `opam env`, and finally we download `dune`, the build system.

```bash
opam switch create . ocaml-base-compiler.4.13.1
eval $(opam env)
opam install dune
```

### Install the dependencies

```bash
opam install . --deps-only
```

### Setup the db

Run the following command and it will create a sqlite db and insert a placeholder user inside

```
make setup
```

## :zap: Run the server

```bash
make run
```

## :hammer: Build the project

This command will build the project

```bash
make build
```

This command will build the project and rebuild it when you update a file

```bash
make build/watch
```
