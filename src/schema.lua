local typedefs = require "kong.db.schema.typedefs"

return {
  name ="kong-cluster-drain",
  fields = {
    { protocols = typedefs.protocols_http },
    { consumer = typedefs.no_consumer },
    { config = {
        type = "record",
        fields = {
          { hostname = {type = "string", default = ""}, },
    }, }, },
  },
}
