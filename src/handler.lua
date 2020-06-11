local host = os.getenv("SPLUNK_HOST") --Ex: gateway-datacenter.company.com
local kong = kong

local KongClusterDrain = {}

KongClusterDrain.PRIORITY = 3 --The standard request termination plugin is 2 so we need to run before that and beat it out in priority.
KongClusterDrain.VERSION = "1.3"

function KongClusterDrain:access(conf)
 --If host has been set check if match and start throwing http status for maintenance
 if conf.hostname == host then
  return kong.response.exit(503, { message = "Scheduled Maintenance" })
 end

 --If no match on host then just return
 return
end

return KongClusterDrain
