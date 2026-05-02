# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is the **specification repository** for the FAIR (Federated and Independent Repositories) Package Management Protocol — a decentralized package management system built for the WordPress ecosystem. The repo contains:

- The core protocol specification (`specification.md`)
- Extension specs (`ext-*.md`, `registry.md`, `spec-labeling.md`)
- Documentation for vendors, implementers, and moderators (`docs/`)
- A JSON Schema for the FAIR Metadata Document (`schemas/metadata.schema.json`)
- Test data validating that schema (`test-data/*.json`)

There is no application code. All "code" is the JSON schema and the validation test script.

## Running tests

```bash
npm test
```

This runs `scripts/test.sh`, which validates every `test-data/*.json` file against `schemas/metadata.schema.json` using `ajv-cli` with JSON Schema draft 2020-12.

To validate a single file:
```bash
./node_modules/.bin/ajv validate --spec=draft2020 --strict --strict-tuples=false -c ajv-formats -s schemas/metadata.schema.json -d test-data/<file>.json
```

## Key concepts

- **DID** — Each package has a W3C Decentralized Identifier as its globally-unique ID. The DID resolves to a DID Document that points to the package's repository and signing keys.
- **Repository** — A server that hosts package metadata and binaries. Vendors choose their own; the DID points to it.
- **Aggregator** — A discovery service that indexes many repositories (like a search engine for packages).
- **Metadata Document** — The primary data structure defined in `schemas/metadata.schema.json`. It includes package identity, authors, license, and a list of releases each containing versioned artifacts.

## Schema structure

`schemas/metadata.schema.json` defines the Metadata Document. Key top-level required fields: `@context`, `id` (DID), `type`, `license`, `authors`, `releases`. Each release has a `version` and `artifacts` map; artifacts have optional `url`, `signature`, `checksum`, and `requires-auth`. Dependencies use `requires`/`suggests` with DID or `env:*` keys.

## Contributing

This repo is managed by the FAIR Working Group. The TSC repo (`github.com/fairpm/tsc`) has contributing guidelines. All documentation is CC BY 4.0.
