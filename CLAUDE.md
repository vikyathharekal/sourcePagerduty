# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a forked version of the Airbyte PagerDuty connector, maintained by Harness. It's a manifest-only declarative Airbyte connector that extends the original with full support for the **services** stream. The connector fetches data from PagerDuty's REST API v2 and provides 6 data streams for incident management and organizational data.

## Architecture

### Connector Type
- **Framework**: Airbyte Declarative Source (manifest-only)
- **Base Image**: `airbyte/source-declarative-manifest:6.12.4`
- **Configuration**: YAML-based declarative manifest (`manifest.yaml`)

### Data Streams
The connector provides 6 streams with different sync modes:

**Incremental Streams:**
- `incidents` - PagerDuty incidents with incremental sync
- `incident_logs` - Log entries for each incident (depends on incidents stream)

**Full Refresh Streams:**
- `teams` - PagerDuty teams
- `services` - PagerDuty services (with offset-based pagination)
- `users` - PagerDuty users  
- `priorities` - PagerDuty incident priorities

### Authentication
- **Method**: Token-based authentication via Authorization header
- **Format**: `Authorization: Token token={api_key}`
- **Configuration**: Single required field `token` in config

## Development Commands

### Build and Push
```bash
# Build the Docker image
docker build -t vikyathharekal/sourcePagerduty .

# Push to Docker Hub
docker push vikyathharekal/sourcePagerduty
```

### Local Testing
```bash
# Check connection
docker run --rm -v $(pwd)/secrets:/secrets vikyathharekal/sourcePagerduty check --config /secrets/config.json

# Discover streams
docker run --rm -v $(pwd)/secrets:/secrets vikyathharekal/sourcePagerduty discover --config /secrets/config.json

# Run acceptance tests
python -m pytest integration_tests/ -p no:warnings
```

### Configuration Setup
Create `secrets/config.json` for testing:
```json
{
  "token": "your-pagerduty-api-token"
}
```

## Key Configuration Details

### Services Stream (Main Enhancement)
The services stream includes custom pagination configuration:
- **Endpoint**: `GET https://api.pagerduty.com/services`
- **Pagination**: Offset-based with 25 records per page
- **Response Path**: `.services[]`

### Acceptance Testing
- **Test Config**: `acceptance-test-config.yml`
- **Strictness Level**: Low
- **Tests**: Connection, discovery, basic read, full refresh
- **Bypassed**: Incremental sync (not implemented for most streams)

### Schema Definitions
All schemas are inline-defined in the manifest with comprehensive field definitions supporting nullable types and complex objects. The schemas cover the full PagerDuty API response structures including nested objects for escalation policies, teams, and user details.

## PagerDuty API Integration

### Base Configuration
- **URL Base**: `https://api.pagerduty.com`
- **API Version**: v2
- **Rate Limiting**: Handled by Airbyte framework
- **Retries**: Configurable via `max_retries` parameter (0-8, default 5)

### Stream-Specific Behavior
- **incident_logs**: Uses SubstreamPartitionRouter to fetch logs per incident
- **services**: Custom offset pagination with configurable page size
- **Other streams**: Standard pagination with default parameters