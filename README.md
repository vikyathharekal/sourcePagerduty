# sourcePagerduty - Forked PagerDuty Airbyte Connector

This is a forked version of the [airbyte/source-pagerduty](https://github.com/airbytehq/airbyte/tree/master/airbyte-integrations/connectors/source-pagerduty) connector, maintained by Harness.

## What's Different

This fork extends the original Airbyte PagerDuty connector with full support for the **services** stream. The original connector is a manifest-only declarative Airbyte connector, and this fork preserves that architecture while ensuring the services stream is properly configured.

### Streams Included

| Stream | Sync Mode | Description |
|--------|-----------|-------------|
| **incidents** | Incremental | PagerDuty incidents |
| **incident_logs** | Incremental | Log entries for each incident |
| **teams** | Full Refresh | PagerDuty teams |
| **services** | Full Refresh | PagerDuty services (with offset-based pagination) |
| **users** | Full Refresh | PagerDuty users |
| **priorities** | Full Refresh | PagerDuty incident priorities |

### Services Stream Details

The **services** stream fetches data from the PagerDuty REST API v2:

- **Endpoint**: `GET https://api.pagerduty.com/services`
- **Authentication**: Token-based (`Authorization: Token token={api_key}`)
- **Pagination**: Offset-based with `offset` and `limit` parameters (25 records per page)
- **Response path**: `.services[]`
- **Key fields**: `id`, `name`, `summary`, `description`, `status`, `html_url`, `self`, `created_at`, `updated_at`, `type`, `escalation_policy`, `teams`, `alert_creation`

## Configuration

The connector requires a PagerDuty API token. Configure the following in your Airbyte connection:

- **Token** (required): Your PagerDuty API key for authentication

## Building and Running

### Build the Docker image

```bash
docker build -t vikyathharekal/sourcePagerduty .
```

### Push to Docker Hub

```bash
docker push vikyathharekal/sourcePagerduty
```

### Run locally

```bash
# Check connection
docker run --rm -v $(pwd)/secrets:/secrets vikyathharekal/sourcePagerduty check --config /secrets/config.json

# Discover streams
docker run --rm -v $(pwd)/secrets:/secrets vikyathharekal/sourcePagerduty discover --config /secrets/config.json
```

Create a `secrets/config.json` file with your PagerDuty token:

```json
{
  "token": "your-pagerduty-api-token"
}
```

## Original Connector

Based on: [airbyte/source-pagerduty](https://github.com/airbytehq/airbyte/tree/master/airbyte-integrations/connectors/source-pagerduty)

- [PagerDuty API Reference](https://developer.pagerduty.com/api-reference/)
- [PagerDuty Authentication](https://developer.pagerduty.com/docs/ZG9jOjExMDI5NTUw-authentication)
# sourcePagerduty
