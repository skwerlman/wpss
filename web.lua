
local constants = require 'constants'
local json = require 'cjson'

local function merge_params(params)
	local querystring = '?'
	for k,v in pairs(params) do
		if querystring == '?' then -- first param
			querystring = ('%s%s=%s'):format(querystring, k, v)
		else
			querystring = ('%s&%s=%s'):format(querystring, k, v)
		end
	end
	return querystring
end

local function responseFactory(status, headers)
	return function (params)
		local status = status
		local response = {
			body = json.encode({
				status = status,
				statusText = constants(tostring(status))
			}),
			status = status,
			headers = headers
		}
		for k,v in pairs(response.headers) do
			response.headers[k] = v:gsub('{{ URI_QUERY }}', merge_params(params))
		end
		return response
	end
end

local web = {}

web.movedPermanently = function(newpath)
	return responseFactory(301, {['Location'] = newpath})
end

web.found = function(newpath)
	return responseFactory(302, {['Location'] = newpath})
end

web.temporaryRedirect = function(newpath)
	return responseFactory(307, {['Location'] = newpath})
end

web.permantRedirect = function(newpath)
	return responseFactory(308, {['Location'] = newpath})
end

return web
