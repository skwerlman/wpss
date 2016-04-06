
local web = require 'web'

local prettyprint = require 'pl.pretty'.write
local log = require 'log'

local router = dofile 'router.lua' -- local copy only
local r = router.new()

local api = dofile 'api.lua'

-- example api
r:get('/api/:foo/*bar', api.success)
r:any('/api/status', api.returnStatus)

-- redirect test
r:get('/api/respcode', web.movedPermanently('http://192.168.8.61/api/status{{ URI_QUERY }}'))

return r
