---@diagnostic disable
local assert = require('luassert')
local basic = require('src.basic')

describe('unpackFull:', function()
	it('unpack difference', function()
		local t = {1, nil, 3}
		assert.are.same({unpack(t)}, {1, nil, 3})
		assert.are.same({basic.unpackFull(t)}, {1, nil, 3})

		t[5] = 5
		assert.are.same({unpack(t)}, {1})
		assert.are.same({basic.unpackFull(t)}, {1, nil, 3, nil, 5})
	end)
	
	it('array fix', function()
		local t = {}
		t[1] = nil
		t[2] = nil
		t[3] = 3
		assert.are.equal(#t, 0)
		t = {basic.unpackFull(t)}
		assert.are.equal(#t, 3)
	end)
end)