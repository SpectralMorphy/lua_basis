---@diagnostic disable
local assert = require('luassert')
local basic = require('src.basic')

describe('type checks:', function()
	it('callable', function()
		local f = function() print('called') end
		local t = {}
		local ft = {}
		setmetatable(ft, { __call = f })
	
		assert.is_true(basic.TYPES.CALLABLE.check(f))
		assert.is_false(basic.TYPES.CALLABLE.check(t))
		assert.is_true(basic.TYPES.CALLABLE.check(ft))
	end)
end)