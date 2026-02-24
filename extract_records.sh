#!/bin/bash

echo "🚀 Extracting PagerDuty Analytics Data..."
echo "========================================="

# Create test/data directory if it doesn't exist
mkdir -p test/data

# Extract service analytics
echo "📊 Extracting service analytics records..."
docker run --rm -v $(pwd):/workspace -v $(pwd)/secrets:/secrets -w /workspace vikyathharekal/sourcepagerduty read --config /secrets/config.json --catalog test/catalogs/test_catalog_service_analytics.json | \
  grep '"type":"RECORD"' | \
  jq -s '[.[] | .record.data]' > test/data/service_analytics_data.json

echo "✅ Service analytics data saved to: test/data/service_analytics_data.json"
service_count=$(cat test/data/service_analytics_data.json | jq '. | length')
echo "   📈 Services found: $service_count"

echo ""

# Extract team analytics  
echo "👥 Extracting team analytics records..."
docker run --rm -v $(pwd):/workspace -v $(pwd)/secrets:/secrets -w /workspace vikyathharekal/sourcepagerduty read --config /secrets/config.json --catalog test/catalogs/test_catalog_team_analytics.json | \
  grep '"type":"RECORD"' | \
  jq -s '[.[] | .record.data]' > test/data/team_analytics_data.json

echo "✅ Team analytics data saved to: test/data/team_analytics_data.json"
team_count=$(cat test/data/team_analytics_data.json | jq '. | length')
echo "   📈 Team records found: $team_count"

echo ""

# Extract both analytics streams combined
echo "🔄 Extracting combined analytics (both service and team)..."
docker run --rm -v $(pwd):/workspace -v $(pwd)/secrets:/secrets -w /workspace vikyathharekal/sourcepagerduty read --config /secrets/config.json --catalog test/catalogs/test_catalog_analytics.json | \
  grep '"type":"RECORD"' | \
  jq -s '[.[] | .record]' > test/data/combined_analytics_data.json

echo "✅ Combined analytics data saved to: test/data/combined_analytics_data.json"
combined_count=$(cat test/data/combined_analytics_data.json | jq '. | length')
echo "   📈 Total records found: $combined_count"

echo ""
echo "🎉 Extraction complete!"
echo "📁 Files created in test/data/:"
echo "   • service_analytics_data.json ($service_count records)"
echo "   • team_analytics_data.json ($team_count records)" 
echo "   • combined_analytics_data.json ($combined_count records)"