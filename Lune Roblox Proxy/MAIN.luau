--!optimize 2

local Log = require("libs/Log")

local serde = require("@lune/serde") -- Encoding/Decoding
local stdio = require("@lune/stdio") -- io tasks
local task = require("@lune/task") -- delaying and coroutines
local net = require("@lune/net") -- networking
local fs = require("@lune/fs") -- filesystem

-- ≡Type Definition≡ --
local GroupType = require("typedef/groups");
-- ≡Type Definition≡ --

-- BasePath is the name of the service.
-- PathLead is rest of the path, used to exactly pinpoint what is being asked for. 
local function splitPath(path: string): { BasePath: string, PathLead: {string}}
	local fullPath = path:gsub("^/", ""):split("/")

	local ReturnPath = {
		BasePath = fullPath[1],
		PathLead = (function()
			table.remove(fullPath, 1)

			return fullPath
		end)()
	}

	return ReturnPath
end

local Services: {[string]: (net.ServeRequest, Path: typeof(splitPath(""))) -> net.ServeResponse} = {
	[""] = function(Request)

		return {
			status = 404,

			headers = DefaultHeader,

			body = "Request PATH was left empty, server cannot process void. :c",
		}
	end,

	GetUserGroupRole = function(Request)
		-- Heya! Apparently I can't send 400 errors with error-messages through roblox.
		-- To make sure the request did not fail: check if the response can be decoded with HttpService:JSONDecode(response)
	
		-- TODO: switch to GET instead of POST requests (Complete, further requests must be in "GET")

		local requestHeaders = Request.headers

		local userId: number? = tonumber(requestHeaders.userid)
		local groupId: number? = tonumber(requestHeaders.groupid)

		-- Checking if "userId" and "groupId" parameters are defined.
		if not (requestHeaders.userid and requestHeaders.groupid) then
			return {
				status = 200,

				body = `{
					if not requestHeaders.userid and not requestHeaders.groupid then
						"userId and groupId parameters were"
					elseif not requestHeaders.userid then
						"userId parameter was"
					else
						"groupId parameter wes"
				} not defined in Headers! (400: malformed JSON given)`
			}
		elseif not (userId and groupId) then
			return {
				status = 200,

				body = `{
					if not userId and not groupId then
						"userId and groupId parameters are"
					elseif not userId then
						"userId parameter is"
					else
						"groupId parameter is"
				} malformed! Please re-check if they are valid numbers! (400: invalid IDs provided)`
			}
		end

		local userGroups: {GroupType.TypeGroup};

		local Success, Result = pcall(function()
			userGroups = net.jsonDecode(
				net.request({
					url = `https://groups.roblox.com/v1/users/{userId}/groups/roles`,
					method = "GET"
				}).body
			).data
		end)

		if not Success then
			return {
				status = 200,
				body = `GroupsAPI resource failed because: {Result}`
			}
		end
		
		for _, GroupData in userGroups do
			if GroupData.group.id == groupId then
				-- yippe we found the group.

				return{
					status = 200,
					body = net.jsonEncode(GroupData.role)
				}
			end
		end


		-- indicates that the player is not in the given group.
		return {
			status = 404,

			body = net.jsonEncode {
				id = 0,
				rank = 0,
				name = "<nil>"
			}
		}
	end

}

AppHandle = net.serve(65379 --[[ just dont use a widely-used port ]], function(Request)
	local simplifiedPath = splitPath(Request.path)
	local ProxyService = Services[simplifiedPath.BasePath];

	if ProxyService then
		return ProxyService(Request, simplifiedPath)
	else
		return {
			status = 404,
			body = `Your requested resource: "{Request.path}" does not exist in our servers. Did you make a typo? (404: service non-existant)`,
		}
	end
end)

Log.Info(`☼ App is now running at port {AppHandle.port}! ☼`)