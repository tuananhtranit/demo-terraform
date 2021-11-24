resource "azurerm_resource_group" "example" {
  name     = "ttresoucegroupdemo"
  location = "eastus2"
}

resource "azurerm_application_insights" "example" {
  name                = "tf-51263562temp-appinsights"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_monitor_action_group" "action_group_alert" {
  name                = "action-group-consumer-alert-bdd"
  resource_group_name = var.resource_group
  short_name          = "ag-consumerbdd"

  email_receiver {
    name          = "Tuan"
    email_address = "trantu02@risk.regn.net"
  }

  arm_role_receiver {
    name                    = "sentorolemonitoringreader"
    role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }

   arm_role_receiver {
    name                    = "sentorolemonitoringcontributor"
    role_id                 = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "example" {
  name                =  "monitor-consumer-availability-bdd"
  location            = eastus2
  resource_group_name = var.resource_group

  action {
    action_group           =  [ azurerm_monitor_action_group.action_group_alert.id ]
    email_subject          = "Avalability alert of site abc"
  }

  data_source_id = azurerm_application_insights.apinsights.id
  description    = "Avalability alert of site"
  enabled        = true
  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
 availabilityResults 
| where timestamp >= ago(10min)  and success==0
| summarize count() by bin(timestamp, 10m)
| order by timestamp asc | render timechart
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 5
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }
}

resource "azurerm_application_insights_web_test" "example" {
  name                    = "tf-temp-appinsights-webtest"
  location                = azurerm_application_insights.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = ["us-tx-sn1-azr", "us-il-ch1-azr"]

  configuration = <<XML
<WebTest Name="WebTest1" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="http://microsoft.com" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML

}

output "webtest_id" {
  value = azurerm_application_insights_web_test.example.id
}

output "webtests_synthetic_id" {
  value = azurerm_application_insights_web_test.example.synthetic_monitor_id
}