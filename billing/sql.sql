"all projects breakdown:"


SELECT
  CURRENT_TIMESTAMP() AS time,
  IF(pos > 50, 'Other', metric) AS metric,
  SUM(value) AS value
FROM (
  SELECT
    project.name AS metric,
    (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value,
    ROW_NUMBER() OVER (ORDER BY SUM(cost) DESC) AS pos
  FROM
    `$source_table`
  WHERE
    $__timeFilter(usage_start_time) AND
    project.id IN ($project)
  GROUP BY 1
)
GROUP BY 2
ORDER BY metric != 'Other' DESC, 3 DESC



"Total Cost"

SELECT CURRENT_TIMESTAMP() AS time, (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value FROM $source_table WHERE $__timeFilter(usage_start_time) AND project.id IN ($project) GROUP BY 1 ORDER BY 1 ASC





"service breakdown"

SELECT *
FROM (
  SELECT
    $__timeGroup(usage_start_time, 1d),
    service.description AS metric,
    (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value
  FROM
    `$source_table`
  WHERE
    $__timeFilter(usage_start_time) AND project.id IN ($project)
  GROUP BY 1, 2
  ORDER BY 1 ASC
)
WHERE value > 0


some ideas: 
Get a high-level view of your costs
Use the Overview page for a high-level look at the net costs for the current and previous invoice months, the costs for your top services, and daily costs for the last 30 days.

Use the Trends page to compare your costs for different periods, such as the current month and the last month, or the current quarter and last quarter.

Use the Analysis page to analyze your costs over time, and identify anomalies such as unusually high or low spending.

Identify your cost drivers
Use the following pages to find where youre spending the most:

Cost by service by month
Cost by project by month
Cost by project, service, and SKU
Cost by region



for development: 
SELECT
  DISTINCT
    sum(cost),
    project.name AS project_name,
    service.description AS service_name,
    xxx
FROM
  `$source_table`
WHERE service.description = 'Kubernetes Engine' and project.name = 'dbg-energy-dev-659ba550'
group by project.name, service.description, xxx
LIMIT 1000;












JSON:
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "datasource",
          "uid": "grafana"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "Displays GCP billing costs straight from BigQuery.",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "gnetId": 18449,
  "graphTooltip": 1,
  "id": 158,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "This query provides a daily overview of costs for each project.",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 60,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "WITH daily_costs AS (\r\n  SELECT\r\n    project.name AS project_name,\r\n    FORMAT_TIMESTAMP('%Y-%m-%d', usage_start_time) AS usage_day,\r\n    SUM(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0)) AS total_cost\r\n  FROM $source_table\r\n  WHERE $__timeFilter(usage_start_time)\r\n    AND project.id IN ($project)\r\n  GROUP BY project_name, usage_day\r\n)\r\nSELECT\r\n  project_name,\r\n  usage_day,\r\n  total_cost\r\nFROM daily_costs\r\nWHERE total_cost > 0\r\nORDER BY usage_day, project_name;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Daily Cost Overview",
      "type": "table"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "query compares total yearly costs across different projects.",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "fillOpacity": 80,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineWidth": 1,
            "scaleDistribution": {
              "type": "linear"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 58,
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "fullHighlight": false,
        "groupWidth": 0.7,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "right",
          "showLegend": true
        },
        "orientation": "horizontal",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": {
          "mode": "single",
          "sort": "none"
        },
        "xTickLabelRotation": 0,
        "xTickLabelSpacing": 100
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "WITH yearly_costs AS (\r\n  SELECT\r\n    project.name AS project_name,\r\n    FORMAT_TIMESTAMP('%Y', usage_start_time) AS usage_year,\r\n    SUM(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0)) AS total_cost\r\n  FROM $source_table\r\n  WHERE $__timeFilter(usage_start_time)\r\n    AND project.id IN ($project)\r\n  GROUP BY project_name, usage_year\r\n)\r\nSELECT\r\n  project_name,\r\n  usage_year,\r\n  total_cost\r\nFROM yearly_costs\r\nWHERE total_cost > 0\r\nORDER BY usage_year, total_cost DESC;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Cost Comparison Between Projects",
      "type": "barchart"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "This query analyzes the cost growth for each project month over month.\n\n",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "continuous-GrYlRd"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 7,
        "w": 24,
        "x": 0,
        "y": 8
      },
      "id": 59,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "WITH monthly_costs AS (\r\n  SELECT\r\n    project.name AS project_name,\r\n    FORMAT_TIMESTAMP('%Y-%m', usage_start_time) AS usage_month,\r\n    SUM(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0)) AS total_cost\r\n  FROM $source_table\r\n  WHERE $__timeFilter(usage_start_time)\r\n    AND project.id IN ($project)\r\n  GROUP BY project_name, usage_month\r\n)\r\nSELECT\r\n  project_name,\r\n  usage_month,\r\n  total_cost,\r\n  total_cost - LAG(total_cost) OVER (PARTITION BY project_name ORDER BY usage_month) AS cost_growth\r\nFROM monthly_costs\r\nWHERE total_cost > 0\r\nORDER BY project_name, usage_month;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Cost Growth Analysis by Project",
      "type": "table"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "This query retrieves the total costs for each project and service per month.\n\n",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 10,
        "w": 24,
        "x": 0,
        "y": 15
      },
      "id": 57,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "displayName": "total_cost"
          }
        ]
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "WITH monthly_service_costs AS (\r\n  SELECT\r\n    project.name AS project_name,\r\n    service.description AS service_name,\r\n    FORMAT_TIMESTAMP('%Y-%m', usage_start_time) AS usage_month,\r\n    SUM(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0)) AS total_cost\r\n  FROM $source_table\r\n  WHERE $__timeFilter(usage_start_time)\r\n    AND project.id IN ($project)\r\n  GROUP BY project_name, service_name, usage_month\r\n)\r\nSELECT\r\n  project_name,\r\n  service_name,\r\n  usage_month,\r\n  total_cost\r\nFROM monthly_service_costs\r\nWHERE total_cost > 0\r\nORDER BY usage_month, project_name, service_name;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Monthly Cost Breakdown by Project and Service",
      "type": "table"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "continuous-GrYlRd"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 11,
        "w": 24,
        "x": 0,
        "y": 25
      },
      "id": 56,
      "options": {
        "displayMode": "lcd",
        "maxVizHeight": 300,
        "minVizHeight": 16,
        "minVizWidth": 8,
        "namePlacement": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [],
          "fields": "",
          "values": true
        },
        "showUnfilled": true,
        "sizing": "auto",
        "valueMode": "color"
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "SELECT\r\n  service.description AS service_name,\r\n  SUM(cost) AS total_cost,\r\n  SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c WHERE c.name = 'Commitment-based Discount'), 0)) AS commitment_discount\r\nFROM $source_table\r\nWHERE $__timeFilter(usage_start_time)\r\n  AND project.id IN ($project)\r\nGROUP BY service_name\r\nHAVING commitment_discount = 0\r\nORDER BY total_cost DESC;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Top Services with No Committed Usage Discount",
      "type": "bargauge"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "SKUs give granular visibility into resource usage and cost per specific resource type.",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "sku_name"
            },
            "properties": [
              {
                "id": "custom.width",
                "value": 664
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 9,
        "w": 24,
        "x": 0,
        "y": 36
      },
      "id": 55,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "displayName": "total_cost"
          }
        ]
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "SELECT\r\n  sku.description AS sku_name,\r\n  invoice.month,\r\n  SUM(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0)) AS total_cost\r\nFROM $source_table\r\nWHERE $__timeFilter(usage_start_time)\r\n  AND project.id IN ($project)\r\nGROUP BY sku_name, invoice.month\r\nHAVING total_cost > 0\r\nORDER BY invoice.month ASC, total_cost DESC;\r\n",
          "refId": "A",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        }
      ],
      "title": "Cost Trend by SKU (Stock Keeping Unit)",
      "type": "table"
    },
    {
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 45
      },
      "id": 54,
      "panels": [],
      "title": "Overview of Costs (Last 1 Year)",
      "type": "row"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "fieldMinMax": false,
          "mappings": [
            {
              "options": {
                "from": 0,
                "result": {
                  "color": "yellow",
                  "index": 0,
                  "text": "<1K EUR"
                },
                "to": 999
              },
              "type": "range"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "currencyEUR"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 20,
        "w": 17,
        "x": 0,
        "y": 46
      },
      "id": 51,
      "maxDataPoints": 50,
      "options": {
        "displayMode": "gradient",
        "maxVizHeight": 300,
        "minVizHeight": 16,
        "minVizWidth": 8,
        "namePlacement": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "showUnfilled": false,
        "sizing": "auto",
        "valueMode": "text"
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 0,
          "group": [],
          "location": "EU",
          "metricColumn": "none",
          "orderByCol": "1",
          "orderBySort": "1",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "SELECT\n  CURRENT_TIMESTAMP() AS time,\n  IF(pos > 50, 'Other', metric) AS metric,\n  SUM(value) AS value\nFROM (\n  SELECT\n    project.name AS metric,\n    (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value,\n    ROW_NUMBER() OVER (ORDER BY SUM(cost) DESC) AS pos\n  FROM\n    `$source_table`\n  WHERE\n    $__timeFilter(usage_start_time) AND\n    project.id IN ($project)\n  GROUP BY 1\n)\nGROUP BY 2\nORDER BY metric != 'Other' DESC, 3 DESC",
          "refId": "A",
          "select": [
            [
              {
                "params": [
                  "-- value --"
                ],
                "type": "column"
              }
            ]
          ],
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          },
          "timeColumn": "-- time --",
          "timeColumnType": "TIMESTAMP",
          "where": [
            {
              "name": "$__timeFilter",
              "params": [],
              "type": "macro"
            }
          ]
        }
      ],
      "title": "All Projects Breakdown",
      "transparent": true,
      "type": "bargauge"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "description": "",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "fixed"
          },
          "decimals": 2,
          "displayName": "Total Cost (EUR)",
          "mappings": [],
          "min": 0,
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "currencyEUR"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 21,
        "w": 6,
        "x": 18,
        "y": 46
      },
      "id": 20,
      "options": {
        "colorMode": "none",
        "graphMode": "none",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "sum"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.2.0",
      "targets": [
        {
          "dataset": "all_billing_data",
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 0,
          "group": [
            {
              "params": [
                "$__interval",
                "none"
              ],
              "type": "time"
            }
          ],
          "location": "EU",
          "metricColumn": "none",
          "orderByCol": "1",
          "orderBySort": "1",
          "partitioned": true,
          "partitionedField": "",
          "project": "shared-it-321504",
          "rawQuery": true,
          "rawSql": "SELECT CURRENT_TIMESTAMP() AS time, (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value FROM $source_table WHERE $__timeFilter(usage_start_time) AND project.id IN ($project) GROUP BY 1 ORDER BY 1 ASC",
          "refId": "A",
          "select": [
            [
              {
                "params": [
                  "cost"
                ],
                "type": "column"
              },
              {
                "params": [
                  "sum"
                ],
                "type": "aggregate"
              },
              {
                "params": [
                  "cost"
                ],
                "type": "alias"
              }
            ]
          ],
          "sharded": false,
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          },
          "table": "",
          "timeColumn": "usage_start_time",
          "timeColumnType": "TIMESTAMP",
          "where": [
            {
              "name": "$__timeFilter",
              "params": [],
              "type": "macro"
            },
            {
              "name": "",
              "params": [
                "project.id",
                "IN",
                "($project)"
              ],
              "type": "expression"
            }
          ]
        }
      ],
      "title": "Total Cost Over Last Year",
      "type": "stat"
    },
    {
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 67
      },
      "id": 53,
      "title": "Charts",
      "type": "row"
    },
    {
      "datasource": {
        "default": false,
        "type": "grafana-bigquery-datasource",
        "uid": "grafana-bigquery-datasource"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": true,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisGridShow": true,
            "axisLabel": "Costs EUR",
            "axisPlacement": "auto",
            "barAlignment": -1,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 17,
            "gradientMode": "opacity",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineStyle": {
              "fill": "solid"
            },
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "decimals": 2,
          "fieldMinMax": false,
          "links": [],
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "currencyEUR"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 10,
        "w": 24,
        "x": 0,
        "y": 68
      },
      "id": 49,
      "options": {
        "legend": {
          "calcs": [
            "sum"
          ],
          "displayMode": "table",
          "placement": "right",
          "showLegend": true,
          "sortBy": "Total",
          "sortDesc": true
        },
        "tooltip": {
          "mode": "multi",
          "sort": "desc"
        }
      },
      "pluginVersion": "9.4.3",
      "targets": [
        {
          "dataset": "all_billing_data",
          "datasource": {
            "type": "grafana-bigquery-datasource",
            "uid": "grafana-bigquery-datasource"
          },
          "editorMode": "code",
          "format": 0,
          "group": [],
          "location": "EU",
          "metricColumn": "none",
          "orderByCol": "1",
          "orderBySort": "1",
          "partitioned": false,
          "partitionedField": "",
          "project": "shared-it-321504",
          "rawQuery": true,
          "rawSql": "SELECT *\nFROM (\n  SELECT\n    $__timeGroup(usage_start_time, 1d),\n    service.description AS metric,\n    (sum(cost) + SUM(IFNULL((SELECT SUM(c.amount) FROM UNNEST(credits) c), 0))) AS value\n  FROM\n    `$source_table`\n  WHERE\n    $__timeFilter(usage_start_time) AND project.id IN ($project)\n  GROUP BY 1, 2\n  ORDER BY 1 ASC\n)\nWHERE value > 0",
          "refId": "A",
          "select": [
            [
              {
                "params": [
                  "-- value --"
                ],
                "type": "column"
              }
            ]
          ],
          "sharded": false,
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          },
          "timeColumn": "-- time --",
          "timeColumnType": "TIMESTAMP",
          "where": [
            {
              "name": "$__timeFilter",
              "params": [],
              "type": "macro"
            }
          ]
        }
      ],
      "title": "Services Breakdown",
      "transparent": true,
      "type": "timeseries"
    }
  ],
  "refresh": "1d",
  "revision": 1,
  "schemaVersion": 39,
  "tags": [
    "GCP",
    "CostTracking"
  ],
  "templating": {
    "list": [
      {
        "current": {
          "selected": true,
          "text": [
            "dbg-energy-dev-659ba550",
            "dbg-energy-epex-rtm-dev-10"
          ],
          "value": [
            "dbg-energy-dev-659ba550",
            "dbg-energy-epex-rtm-dev-10"
          ]
        },
        "datasource": {
          "type": "grafana-bigquery-datasource",
          "uid": "grafana-bigquery-datasource"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "Project",
        "multi": true,
        "name": "project",
        "options": [],
        "query": {
          "0": "S",
          "1": "E",
          "2": "L",
          "3": "E",
          "4": "C",
          "5": "T",
          "6": " ",
          "7": "D",
          "8": "I",
          "9": "S",
          "10": "T",
          "11": "I",
          "12": "N",
          "13": "C",
          "14": "T",
          "15": " ",
          "16": "p",
          "17": "r",
          "18": "o",
          "19": "j",
          "20": "e",
          "21": "c",
          "22": "t",
          "23": ".",
          "24": "i",
          "25": "d",
          "26": " ",
          "27": "F",
          "28": "R",
          "29": "O",
          "30": "M",
          "31": " ",
          "32": "`",
          "33": "$",
          "34": "s",
          "35": "o",
          "36": "u",
          "37": "r",
          "38": "c",
          "39": "e",
          "40": "_",
          "41": "t",
          "42": "a",
          "43": "b",
          "44": "l",
          "45": "e",
          "46": "`",
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "SELECT DISTINCT project.id FROM `$source_table`",
          "refId": "tempvar",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        },
        "refresh": 1,
        "regex": "/dbg-energy-.*/",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "dbg-central-audit",
          "value": "dbg-central-audit"
        },
        "hide": 0,
        "label": "Source Project",
        "name": "source_project",
        "options": [
          {
            "selected": true,
            "text": "dbg-central-audit",
            "value": "dbg-central-audit"
          }
        ],
        "query": "dbg-central-audit",
        "skipUrlSync": false,
        "type": "textbox"
      },
      {
        "current": {
          "selected": false,
          "text": "billing_data",
          "value": "billing_data"
        },
        "hide": 0,
        "label": "Source Dataset",
        "name": "source_dataset",
        "options": [
          {
            "selected": true,
            "text": "billing_data",
            "value": "billing_data"
          }
        ],
        "query": "billing_data",
        "skipUrlSync": false,
        "type": "textbox"
      },
      {
        "current": {
          "selected": true,
          "text": "dbg-central-audit.billing_data.gcp_billing_export_v1_01029D_2E4AE6_9BE44D",
          "value": "dbg-central-audit.billing_data.gcp_billing_export_v1_01029D_2E4AE6_9BE44D"
        },
        "datasource": {
          "type": "grafana-bigquery-datasource",
          "uid": "grafana-bigquery-datasource"
        },
        "definition": "",
        "hide": 0,
        "includeAll": false,
        "label": "Source Table",
        "multi": false,
        "name": "source_table",
        "options": [],
        "query": {
          "editorMode": "code",
          "format": 1,
          "location": "EU",
          "project": "dbg-energy-sz-ceff08bc",
          "rawQuery": true,
          "rawSql": "SELECT CONCAT(table_catalog, \".\", table_schema, \".\", table_name) FROM `$source_project.$source_dataset.INFORMATION_SCHEMA.TABLES` WHERE REGEXP_CONTAINS(table_name, \"^gcp_billing_export_v1_\")",
          "refId": "tempvar",
          "sql": {
            "columns": [
              {
                "parameters": [],
                "type": "function"
              }
            ],
            "groupBy": [
              {
                "property": {
                  "type": "string"
                },
                "type": "groupBy"
              }
            ],
            "limit": 50
          }
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      }
    ]
  },
  "time": {
    "from": "now-7d",
    "to": "now"
  },
  "timepicker": {
    "hidden": false,
    "nowDelay": "",
    "refresh_intervals": [
      "1d"
    ]
  },
  "timezone": "",
  "title": "Google Cloud Billing invoice Costs",
  "uid": "0xLhbCB4k",
  "version": 21,
  "weekStart": "monday"
}