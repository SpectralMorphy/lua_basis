---@diagnostic disable
local basic = require('src.basic')

local testFiles = {
	'types',
	'unpackFull',
	'args',
}

function run()
	for _, file in ipairs(testFiles) do
		runFile(file)
	end
end

local env = getfenv(1)

function runFile(file)
	local f, err = loadfile(('test/%s.lua'):format(file))
	if f then
		setfenv(f, env)
		f()
	else
		error(err)
	end
end

function wrap(f)
	basic.try(f, function(err)
		io.write('\27[31m')
		print(err)
		if err.trace then
			print(err:trace())
		end
		io.write('\27[0m')
	end)
end

wrap(run)