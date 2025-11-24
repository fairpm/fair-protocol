#!/usr/bin/env bash

# -o pipefail Produce a failure return code if any command errors
set -o pipefail

# Validate schema files
for file in test-data/*.json
do
	# See https://github.com/ajv-validator/ajv/issues/2241 for strict-tuples
	./node_modules/.bin/ajv validate --spec=draft2020 --strict --strict-tuples=false -c ajv-formats -s schemas/metadata.schema.json -d "$file"
done
