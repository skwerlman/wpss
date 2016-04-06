local constants = require 'constants'
local log = require 'log'
local try = require 'try'

local json = require 'cjson'
local pegasus = require 'pegasus'
local Handler = require 'pegasus.handler' -- needed for pretty logging
local socket = require 'socket' -- needed for pretty logging

--[[ config ]]---------------------------------------------------------

-- TODO replace with config loader
local serverInfo = {
	serverName = 'pegasus',
	serverKind = 'wpss',
	interface = '*',
	port = '80',
	ssl=false, -- untested!
	exposeErrors=true, -- disable in production!!!!
	webRoot = '.'
	-- more info?
}

-----------------------------------------------------------------------

local assert = function(test, message)
	if not test then
		log.error(debug.traceback(message or '', 1))
		os.exit(1)
	end
	return test
end

function pegasus:start(callback) -- override for custom start message
	local handler = Handler:new(callback, self.location, self.plugins)
	local server = assert(socket.bind(serverInfo.interface, self.port))
	local ip, port = server:getsockname()
	log.info('WPSS/Pegasus is up on ' .. ip .. ":".. port)

	while 1 do
		local client = server:accept()
		client:settimeout(1, 'b')
		handler:processRequest(client)
	end
end

local function returnError(respObj, status, msg)
	local e = {}
	e.status = status
	e.body = {
		["status"] = status,
		["statusText"] = constants(tostring(status)),
		["error"] = serverInfo.exposeErrors and msg or 'An error occurred while processing the request',
	}
	respObj:addHeader('Content-Type', 'application/json'):statusCode(status, e.body.statusText):write(json.encode(e.body))
	log.error(debug.traceback(msg or '', 1))
end

local server = pegasus:new({ port=serverInfo.port })

server:start(function (request, response)
	try(function(req, rep)
			-- TODO consider sandboxing routes.lua??
			-- maybe have a util lib loaded or something? idk

			-- we load the routes file using dofile b/c require caches files in _G
			-- we avoid caching here so a route change doesn't mean a server restart
			local r = dofile 'routes.lua'

			-- TODO be smarter about missing routes.lua
			assert(r, 'Failed to load route file!')

			log.trace('trying to ' .. req:method() .. ' ' .. req:path())

			local ok, ok2, result, problem = pcall(r.execute, r, req:method(), req:path(), req:params())
			if ok then -- pcall executed the router
				if ok2 then -- the router returned an object 
					rep:addHeader('Content-Type', 'application/json'):addHeaders(result.headers):statusCode(result.status, constants(tostring(result.status))):write(result.body)
				else -- the router didn't return an object
					local e = 'failed to ' .. req:method() .. ' ' .. req:path() .. '\n' .. (problem or 'unknown problem')
					log.warn(e)
					returnError(rep, 404, e)
				end
			else -- the router crashed
				local e = 'failed to ' .. req:method() .. ' ' .. req:path() .. '\n' .. ok2
				log.error(e)
				returnError(rep, 500, e)
			end
		end, request, response
	):catch(
		function (msg)
			returnError(response, 500, msg)
			log.error(debug.traceback(msg or '', 1))
		end
	)
end)
