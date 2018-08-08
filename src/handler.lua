local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local host = os.getenv("SPLUNK_HOST") --Ex: gateway-datacenter.company.com

local ngx = ngx

local KongClusterDrain = BasePlugin:extend()

KongClusterDrain.PRIORITY = 3 --The standard request termination plugin is 2 so we need to run before that and beat it out in priority.
KongClusterDrain.VERSION = "1.0.0"

local function flush(ctx)
  ctx = ctx or ngx.ctx
  local response = ctx.delayed_response
  local status   = response.status_code
  ngx.status = status
  return ngx.exit(status)
end

function KongClusterDrain:new()
  KongClusterDrain.super.new(self, "kong-cluster-drain")
end

function KongClusterDrain:access(conf)
 KongClusterDrain.super.access(self)
 
 if conf.hostname == host then --If host has been set check if match and start throwing http status for maintenance
  local ctx = ngx.ctx
  if ctx.delay_response and not ctx.delayed_response then
    ctx.delayed_response = {
      status_code  = 503
    }

    ctx.delayed_response_callback = flush

    return
  end

  return responses.send_HTTP_SERVICE_UNAVAILABLE()
 end
 
 return --If no match on host then just return
end

return KongClusterDrain
