#!/usr/bin/luajit

local try = require 'try'
local log = require 'log'

local error = function(message)
	log.fatal(debug.traceback(message or '', 1))
	os.exit(1)
end

try(
	dofile 'wpss.lua'
):catch(
	function (msg)
		error('Unhandled error:\n' .. msg)
	end
)