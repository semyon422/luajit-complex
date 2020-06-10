local ffi = require("ffi")
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local atan2 = math.atan2
local log = math.log
local exp = math.exp
local floor = math.floor
local random = math.random
local pi = math.pi

--------------------------------------------------------------------------------

local complex = ffi.typeof(1i)

local complexpolar = function(r, t)
	return complex(r * cos(t), r * sin(t))
end

local iscomplex = function(a)
	return ffi.istype(complex, a)
end

local tocomplex = function(a)
	if iscomplex(a) then
		return a
	end

	local n = tonumber(a)
	if n then
		return complex(n)
	end

	return complex(a) -- error
end

local assert_int = function(a)
	return assert(floor(a) == a, "k should be integer") and a
end

local complexrandom = function()
	return complexpolar(random(), random() * 2 * pi)
end

--------------------------------------------------------------------------------

local _copy = function(a)
	return complex(a[0], a[1])
end

local _abs = function(a)
	return sqrt(a[0] ^ 2 + a[1] ^ 2)
end

local _arg = function(a)
	return atan2(a[1], a[0])
end

local _polar = function(a)
	return _abs(a), _arg(a)
end

local _exp = function(a)
	local r = exp(a[0])
	return complex(r * cos(a[1]), r * sin(a[1]))
end

local _log = function(a, k)
	return complex(log(_abs(a)), _arg(a) + 2 * pi * (k and assert_int(k) or 0))
end

local _pow = function(a, n, k)
	return _exp(n * _log(a, k))
end

local _sqrt = function(a, k)
	return _pow(a, 0.5, k)
end

local _sin = function(a)
	return (_exp(1i * a) - _exp(-1i * a)) / 2i
end

local _cos = function(a)
	return (_exp(1i * a) + _exp(-1i * a)) / 2
end

local _tan = function(a)
	return _sin(a) / _cos(a)
end

local _cot = function(a)
	return _cos(a) / _sin(a)
end

local _asin = function(a, k1, k2)
	return -1i * _log(1i * a + _pow(1 - _pow(a, 2), 0.5, k2), k1)
end

local _acos = function(a, k1, k2)
	return -1i * _log(a + 1i * _pow(1 - _pow(a, 2), 0.5, k2), k1)
end

local _atan = function(a, k)
	return -1i / 2 * _log((1i - a) / (1i + a), k)
end

local _acot = function(a, k)
	return 1i / 2 * _log((a - 1i) / (a + 1i), k)
end

local _sinh = function(a)
	return (_exp(a) - _exp(-a)) / 2
end

local _cosh = function(a)
	return (_exp(a) + _exp(-a)) / 2
end

local _tanh = function(a)
	return _sinh(a) / _cosh(a)
end

local _coth = function(a)
	return _cosh(a) / _sinh(a)
end

local _asinh = function(a, k1, k2)
	return 1i * _asin(-1i * a, k1, k2)
end

local _acosh = function(a, k1, k2)
	return 1i * _acos(a, k1, k2)
end

local _atanh = function(a, k)
	return 1i * _atan(-1i * a, k)
end

local _acoth = function(a, k)
	return 1i * _acot(1i * a, k)
end

local _conj = function(a) -- conjugate
	return complex(a[0], -a[1])
end

--------------------------------------------------------------------------------

local cmath = {}
local cplex = {}

cmath.complex = complex
cmath.complexpolar = complexpolar
cmath.iscomplex = iscomplex
cmath.tocomplex = tocomplex
cmath.random = complexrandom

cmath.copy	= function(a, ...) return _copy(tocomplex(a), ...) end
cmath.abs	= function(a, ...) return _abs(tocomplex(a), ...) end
cmath.arg	= function(a, ...) return _arg(tocomplex(a), ...) end
cmath.polar	= function(a, ...) return _polar(tocomplex(a), ...) end
cmath.pow	= function(a, ...) return _pow(tocomplex(a), ...) end
cmath.sqrt	= function(a, ...) return _sqrt(tocomplex(a), ...) end
cmath.log	= function(a, ...) return _log(tocomplex(a), ...) end
cmath.exp	= function(a, ...) return _exp(tocomplex(a), ...) end
cmath.sin	= function(a, ...) return _sin(tocomplex(a), ...) end
cmath.cos	= function(a, ...) return _cos(tocomplex(a), ...) end
cmath.tan	= function(a, ...) return _tan(tocomplex(a), ...) end
cmath.cot	= function(a, ...) return _cot(tocomplex(a), ...) end
cmath.asin	= function(a, ...) return _asin(tocomplex(a), ...) end
cmath.acos	= function(a, ...) return _acos(tocomplex(a), ...) end
cmath.atan	= function(a, ...) return _atan(tocomplex(a), ...) end
cmath.acot	= function(a, ...) return _acot(tocomplex(a), ...) end
cmath.sinh	= function(a, ...) return _sinh(tocomplex(a), ...) end
cmath.cosh	= function(a, ...) return _cosh(tocomplex(a), ...) end
cmath.tanh	= function(a, ...) return _tanh(tocomplex(a), ...) end
cmath.coth	= function(a, ...) return _coth(tocomplex(a), ...) end
cmath.asinh	= function(a, ...) return _asinh(tocomplex(a), ...) end
cmath.acosh	= function(a, ...) return _acosh(tocomplex(a), ...) end
cmath.atanh	= function(a, ...) return _atanh(tocomplex(a), ...) end
cmath.acoth	= function(a, ...) return _acoth(tocomplex(a), ...) end
cmath.conj	= function(a, ...) return _conj(tocomplex(a), ...) end

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

--------------------------------------------------------------------------------

local mt = {}

mt.__index = function(_, key)
	return cplex[key]
end

mt.__eq = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	return a[0] == b[0] and a[1] == b[1]
end

mt.__unm = function(a)
	return complex(-a[0], -a[1])
end

mt.__add = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	return complex(a[0] + b[0], a[1] + b[1])
end

mt.__sub = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	return complex(a[0] - b[0], a[1] - b[1])
end

mt.__mul = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	return complex(a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0])
end

mt.__div = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	local d = b[0] ^ 2 + b[1] ^ 2
	return complex((a[0] * b[0] + a[1] * b[1]) / d, (a[1] * b[0] - a[0] * b[1]) / d)
end

mt.__pow = function(a, b)
	a, b = tocomplex(a), tocomplex(b)
	return _pow(a, b)
end

mt.__mod = function(a, b)
	return error("__mod is not implemented")
end

mt.__len = function(a, b)
	return error("__len is not implemented")
end

mt.__lt = function(a, b)
	return error("__lt is not implemented")
end

mt.__le = function(a, b)
	return error("__le is not implemented")
end

mt.__concat = function(a, b)
	return tostring(a) .. tostring(b)
end

cmath.complex = ffi.metatype(complex, mt)

return cmath
