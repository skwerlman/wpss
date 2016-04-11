--[[ HowTo ]]----------------------------------------------------------
-- This config file is a series of Lua variable definitions
-- Comments in this file begin with two hyphens
-- Semicolons are optional

--[[ General ]]--------------------------------------------------------
interface = '*' -- which interface to bind to
port = 80       -- which port to bind to (atm, only one port at a time)
webRoot = '.'   -- where to look for routes.lua (unimplemented)

--[[ Branding ]]-------------------------------------------------------
server_name = 'reference' -- how to refer to this server instance
server_kind = 'wpss'      -- what kind of server this is (usually wpss)

--[[ SSL ]]------------------------------------------------------------
ssl = false       -- unimplemented!
ssl_pub_key = ''  -- unimplemented
ssl_priv_key = '' -- unimplemented

--[[ Debugging ]]------------------------------------------------------
expose_errors = true  -- whether to pass lua errors to the client
sandbox_routes = true -- whether to actively sandbox routes.lua
