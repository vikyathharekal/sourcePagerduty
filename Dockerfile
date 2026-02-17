FROM airbyte/source-declarative-manifest:6.36.3
COPY manifest.yaml /airbyte/integration_code/source_declarative_manifest/manifest.yaml
