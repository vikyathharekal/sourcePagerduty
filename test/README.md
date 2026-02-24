# Test Directory

This directory contains test configurations and data for the PagerDuty connector.

## Structure

```
test/
├── catalogs/          # Test catalog configurations (committed to git)
│   ├── test_catalog*.json
└── data/              # Generated test data (ignored by git)
    ├── service_analytics_data.json
    ├── team_analytics_data.json
    └── combined_analytics_data.json
```

## Test Catalogs

- `test_catalog.json` - Basic services and incidents
- `test_catalog_analytics.json` - Both analytics streams  
- `test_catalog_service_analytics.json` - Service analytics only
- `test_catalog_team_analytics.json` - Team analytics only
- `test_catalog_services.json` - Services stream only
- `test_catalog_oncalls.json` - Oncalls stream only

## Running Tests

Use the extraction script from the root directory:
```bash
./extract_records.sh
```

This will populate the `data/` directory with real PagerDuty analytics data.

## Note

The `data/` directory is ignored by git to prevent committing sensitive PagerDuty data.