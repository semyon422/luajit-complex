local ffi = require("ffi")
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local atan2 = math.atan2
local log = math.log
local exp = math.exp
local modf = math.modf
local random = math.random
local pi = math.pi

--------------------------------------------------------------------------------

local complex = ffi.typeof(1i)

local iscomplex = function(z)
	return ffi.istype(complex, z)
end

local tocomplex = function(v)
	if iscomplex(v) then
		return v
	end

	return complex(v)  -- Accepts numbers, strings, tables.
end

local assert_int = function(x)
	return assert(x and x % 1 == 0, "k should be integer") and x
end

local frompolar = function(r, t)
	return complex(r * cos(t), r * sin(t))
end

local _random = function()
	return frompolar(random(), random() * 2 * pi)
end

--------------------------------------------------------------------------------

local _copy = function(z)
	return complex(z[0], z[1])
end

local _abs = function(z)
	return sqrt(z[0] ^ 2 + z[1] ^ 2)
end

local _arg = function(z)
	return atan2(z[1], z[0])
end

local _polar = function(z)
	return _abs(z), _arg(z)
end

local _exp = function(z)
	local r = exp(z[0])
	return complex(r * cos(z[1]), r * sin(z[1]))
end

local _log = function(z, k)
	if z == 0 then return 0 / 0	end
	return complex(log(_abs(z)), _arg(z) + 2 * pi * assert_int(k or 0))
end

local _pow = function(z, n, k)
	if z == 0 and n ~= 0 then return 0 end
	return _exp(n * _log(z, k))
end

local _sqrt = function(z, k)
	return _pow(z, 0.5, k)
end

local _sin = function(z)
	return (_exp(1i * z) - _exp(-1i * z)) / 2i
end

local _cos = function(z)
	return (_exp(1i * z) + _exp(-1i * z)) / 2
end

local _tan = function(z)
	return _sin(z) / _cos(z)
end

local _cot = function(z)
	return _cos(z) / _sin(z)
end

--[[
https://en.wikipedia.org/wiki/Inverse_trigonometric_functions
https://en.wikipedia.org/wiki/Inverse_hyperbolic_functions
]]

local _asin = function(z, k1, k2)
	return -1i * _log(1i * z + _pow(1 - _pow(z, 2), 0.5, k2), k1)
end

local _acos = function(z, k1, k2)
	return -1i * _log(z + 1i * _pow(1 - _pow(z, 2), 0.5, k2), k1)
end

local _atan = function(z, k)
	return -1i / 2 * _log((1i - z) / (1i + z), k)
end

local _acot = function(z, k)
	return 1i / 2 * _log((z - 1i) / (z + 1i), k)
end

local _sinh = function(z)
	return (_exp(z) - _exp(-z)) / 2
end

local _cosh = function(z)
	return (_exp(z) + _exp(-z)) / 2
end

local _tanh = function(z)
	return _sinh(z) / _cosh(z)
end

local _coth = function(z)
	return _cosh(z) / _sinh(z)
end

local _asinh = function(z, k1, k2)
	return 1i * _asin(-1i * z, k1, k2)
end

local _acosh = function(z, k1, k2)
	return 1i * _acos(z, k1, k2)
end

local _atanh = function(z, k)
	return 1i * _atan(-1i * z, k)
end

local _acoth = function(z, k)
	return 1i * _acot(1i * z, k)
end

local _conj = function(z)
	return complex(z[0], -z[1])
end

local _modf = function(z)
	local x, dx = modf(z.re)
	local y, dy = modf(z.im)
	return complex(x, y), complex(dx, dy)
end

--------------------------------------------------------------------------------

local cmath = {}
local cplex = {}

cmath.complex = complex
cmath.frompolar = frompolar
cmath.iscomplex = iscomplex
cmath.tocomplex = tocomplex
cmath.random = _random

cplex.copy	= _copy
cplex.abs	= _abs
cplex.arg	= _arg
cplex.polar	= _polar
cplex.pow	= _pow
cplex.sqrt	= _sqrt
cplex.log	= _log
cplex.exp	= _exp
cplex.sin	= _sin
cplex.cos	= _cos
cplex.tan	= _tan
cplex.cot	= _cot
cplex.asin	= _asin
cplex.acos	= _acos
cplex.atan	= _atan
cplex.acot	= _acot
cplex.sinh	= _sinh
cplex.cosh	= _cosh
cplex.tanh	= _tanh
cplex.coth	= _coth
cplex.asinh	= _asinh
cplex.acosh	= _acosh
cplex.atanh	= _atanh
cplex.acoth	= _acoth
cplex.conj	= _conj
cplex.modf	= _modf

--------------------------------------------------------------------------------

local mt = {}

mt.__index = function(_, key)
	return cplex[key]
end

mt.__eq = function(z, c)
	z, c = tocomplex(z), tocomplex(c)
	return z[0] == c[0] and z[1] == c[1]
end

mt.__unm = function(z)
	return complex(-z[0], -z[1])
end

mt.__add = function(z, c)
	z, c = tocomplex(z), tocomplex(c)
	return complex(z[0] + c[0], z[1] + c[1])
end

mt.__sub = function(z, c)
	z, c = tocomplex(z), tocomplex(c)
	return complex(z[0] - c[0], z[1] - c[1])
end

mt.__mul = function(z, c)
	z, c = tocomplex(z), tocomplex(c)
	return complex(z[0] * c[0] - z[1] * c[1], z[0] * c[1] + z[1] * c[0])
end

mt.__div = function(z, c)
	z, c = tocomplex(z), tocomplex(c)
	local d = c[0] ^ 2 + c[1] ^ 2
	return complex((z[0] * c[0] + z[1] * c[1]) / d, (z[1] * c[0] - z[0] * c[1]) / d)
end

mt.__pow = function(z, c)
	return _pow(tocomplex(z), tocomplex(c))
end

mt.__mod = function()
	return error("__mod is not implemented")
end

mt.__len = function(z)
	return _abs(z)
end

mt.__lt = function()
	return error("__lt is not implemented")
end

mt.__le = function()
	return error("__le is not implemented")
end

mt.__concat = function(z, c)
	return tostring(z) .. tostring(c)
end

cmath.complex = ffi.metatype(complex, mt)

return cmath
