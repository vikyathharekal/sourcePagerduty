# sourcePagerduty - Enhanced PagerDuty Airbyte Connector

This is a forked version of the [airbyte/source-pagerduty](https://github.com/airbytehq/airbyte/tree/master/airbyte-integrations/connectors/source-pagerduty) connector, maintained by Harness.

## What's Different

This fork extends the original Airbyte PagerDuty connector with:
- Full support for the **services** stream with proper pagination
- **NEW**: Service analytics stream for performance metrics 
- **NEW**: Team analytics stream for team-level incident metrics
- Enhanced configuration options for analytics data filtering

### Streams Included

| Stream | Sync Mode | Description |
|--------|-----------|-------------|
| **incidents** | Incremental | PagerDuty incidents |
| **incident_logs** | Incremental | Log entries for each incident |  
| **teams** | Full Refresh | PagerDuty teams |
| **services** | Full Refresh | PagerDuty services (with offset-based pagination) |
| **users** | Full Refresh | PagerDuty users |
| **priorities** | Full Refresh | PagerDuty incident priorities |
| **service_analytics** 🆕 | Full Refresh | Service performance analytics and metrics |
| **team_analytics** 🆕 | Full Refresh | Team-level incident analytics and metrics |

### Stream Details

#### Services Stream
The **services** stream fetches data from the PagerDuty REST API v2:
- **Endpoint**: `GET https://api.pagerduty.com/services`
- **Authentication**: Token-based (`Authorization: Token token={api_key}`)
- **Pagination**: Offset-based with `offset` and `limit` parameters (25 records per page)
- **Response path**: `.services[]`
- **Key fields**: `id`, `name`, `summary`, `description`, `status`, `html_url`, `self`, `created_at`, `updated_at`, `type`, `escalation_policy`, `teams`, `alert_creation`

#### Analytics Streams 🆕
Both analytics streams use the PagerDuty Analytics API v2:

**Service Analytics:**
- **Endpoint**: `POST https://api.pagerduty.com/analytics/metrics/incidents/services`
- **Data**: Per-service performance metrics including incident counts, resolution times, uptime percentages
- **Key metrics**: `total_incident_count`, `mean_seconds_to_resolve`, `mean_seconds_to_first_ack`, `up_time_pct`, `total_high_urgency_incidents`

**Team Analytics:**
- **Endpoint**: `POST https://api.pagerduty.com/analytics/metrics/incidents/teams`  
- **Data**: Daily aggregated team-level incident metrics and response performance
- **Key metrics**: `total_incident_count`, `mean_engaged_seconds`, `total_escalation_count`, `total_interruptions`, `range_start` (daily breakdowns)

## Configuration

### Required Configuration
- **Token** (required): Your PagerDuty API key for authentication

### Analytics Configuration Options 🆕
For the new analytics streams, you can optionally configure:

- **Start Date**: Start date for analytics data (ISO 8601 format, default: `2024-01-01T00:00:00Z`)
- **End Date**: End date for analytics data (ISO 8601 format, default: `2024-12-31T23:59:59Z`)
- **Urgency Filter**: Filter incidents by urgency (`high` or `low`)
- **Major Incidents Only**: Boolean flag to include only major incidents
- **Aggregate Unit**: Time unit for aggregation (`day`, `week`, `month`, default: `day`)
- **Time Zone**: Time zone for analytics data (default: `Etc/UTC`)

### Example Configuration
```json
{
  "token": "your-pagerduty-api-token",
  "start_date": "2024-01-01T00:00:00Z",
  "end_date": "2024-12-31T23:59:59Z",
  "urgency": "high",
  "major_incidents_only": true,
  "aggregate_unit": "day",
  "time_zone": "America/New_York"
}
```

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

# Discover all streams (including new analytics streams)
docker run --rm -v $(pwd)/secrets:/secrets vikyathharekal/sourcePagerduty discover --config /secrets/config.json

# Test specific streams
docker run --rm -v $(pwd):/workspace -v $(pwd)/secrets:/secrets -w /workspace vikyathharekal/sourcepagerduty read --config /secrets/config.json --catalog test/catalogs/test_catalog_service_analytics.json
```

### Extract Analytics Data 🆕

Use the provided extraction script to get analytics data:

```bash
./extract_records.sh
```

This will create JSON files in `test/data/` with:
- `service_analytics_data.json` - Service performance metrics
- `team_analytics_data.json` - Team incident analytics
- `combined_analytics_data.json` - Both streams combined

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
