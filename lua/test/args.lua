---@diagnostic disable
local assert = require('luassert')
local basic = require('src.basic')

describe('args:', function()

	local params = {10, 1.5, false, 'string', {1,2,3}}
	local signature = {
		basic.TYPES.INTEGER,
		basic.TYPES.NUMBER,
		basic.TYPES.BOOLEAN,
		basic.TYPES.STRING,
		basic.TYPES.ARRAY
	}

	it('simple match', function()
		local i, n, b, s, a = basic.args(params, signature)
		assert.are.equal(params[1], i)
		assert.are.equal(params[2], n)
		assert.are.equal(params[3], b)
		assert.are.equal(params[4], s)
		assert.are.equal(params[5], a)		
	end)
	
	it('simple mismatch', function()
		params[5].x = 1
		assert.has_error(function()
			basic.args(params, signature)
		end)
	end)
	
	local sign = {
		basic.TYPES.INTEGER,
		{
			checks = basic.TYPES.STRING,
			optional = true,
		},
		basic.TYPES.ANY
	}
		
	it('optional', function()		
		local params1 = {10, 0}
		local i, s, a = basic.args(params1, sign)
		assert.are.equal(params1[1], i)
		assert.are.equal(params1[2], a)
		
		local params2 = {1, '2', 3}
		i, s, a = basic.args(params2, sign)
		assert.are.equal(params2[1], i)
		assert.are.equal(params2[2], s)
		assert.are.equal(params2[3], a)
	end)
	
	it('optional + any', function()
		local params3 = {5}
		local i, s, a = basic.args(params3, sign)
		assert.are.equal(params3[1], i)
		assert.are.equal(params3[2], nil)
		assert.are.equal(params3[3], nil)
		
		sign[3] = basic.TYPES.SOME
		assert.has_error(function()
			i, s, a = basic.args(params3, sign)
		end)
	end)
	
	it('multiple', function()
		local sign = {
			basic.TYPES.STRING,
			{
				checks = {basic.TYPES.INTEGER, basic.TYPES.NIL},
				multiple = true,
			},
			basic.TYPES.STRING,
		}
		
		local params = {'1', 2, 3, nil, 5, '6', nil}
		local l, a, r = basic.args(params, sign)
		assert.are.equal(params[1], l)
		assert.are.same({2, 3, nil, 5}, a)
		assert.are.equal(params[6], r)
		
		params = {'1', '2'}
		assert.has_error(function()
			basic.args(params, sign)
		end)
		
		params = {'1', 2}
		assert.has_error(function()
			basic.args(params, sign)
		end)
		
		params = {'1', '2'}
		sign[2].optional = true
		l, a, r = basic.args(params, sign)
		assert.are.equal(params[1], l)
		assert.are.same({}, a)
		assert.are.equal(params[2], r)
	end)
	
	it('multiple ambigous', function()
		local sign = {
			basic.TYPES.INTEGER,
			{
				checks = basic.TYPES.INTEGER,
				multiple = true,
			},
			basic.TYPES.SOME,
		}
		
		local params = {1, 2, 3, 4}
		local i, a, s = basic.args(params, sign)
		assert.are.equal(params[1], i)
		assert.are.same({2, 3}, a)
		assert.are.equal(params[4], s)
	end)
	
	pending('error message')
end)