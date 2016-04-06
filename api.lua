
local json = require 'cjson'
local constants = require 'constants'

local api = {}

local function code(str)
	str = str:gsub("<", "&lt;"):gsub(">", "&gt;")	
	str = "<pre>" .. str .. "</pre>"
	return str
end

function api.success(params, method)
	return {
		body = json.encode({
			status = 200,
			params = params,
			method = method,
			statusText = constants('200')
		}),
		status = 200,
		headers = {}
	}
end

function api.returnStatus(params)
	local status = params.status or '400'
	status = tonumber(status)
	local i18nProblem = false -- make i18nProblem local and false, which gets replaced w/ nil later
	if not constants(tostring(status)) then
		status = 406 -- "not acceptable"
		i18nProblem = 'invalid/unsupported status code'
	end
	return {
		body = json.encode({
			status = status,
			statusText = constants(tostring(status))
		}),
		['error'] = i18nProblem or nil, -- set error if the status passed is invalid
		status = status,
		headers = {}
	}
end

return api
