local ffi = require("ffi")
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local atan2 = math.atan2
local log = math.log
local exp = math.exp
local pi = math.pi

local complex = ffi.typeof(1i)
local cmath = {}
local mt = {}

local tocomplex = function(a)
	if ffi.istype(complex, a) then
		return a
	end

	return complex(tonumber(a))
end

local cabs = function(a)
	a = tocomplex(a)
	return sqrt(a[0] ^ 2 + a[1] ^ 2)
end

local carg = function(a)
	a = tocomplex(a)
	return atan2(a[1], a[0])
end

local cnpolar = function(a)
	a = tocomplex(a)
	return a:abs(), a:arg()
end

local ccpolar = function(r, f)
	return complex(r * cos(f), r * sin(f))
end

local clog = function(a)
	a = tocomplex(a)
	return complex(log(a:abs()), a:arg())
end

local cexp = function(a)
	a = tocomplex(a)
	local r = exp(a[0])
	return complex(r * cos(a[1]), r * sin(a[1]))
end

local csin = function(a)
	return (cexp(1i * a) - cexp(-1i * a)) / 2i
end

local ccos = function(a)
	return (cexp(1i * a) + cexp(-1i * a)) / 2
end

local ctan = function(a)
	return csin(a) / ccos(a)
end

local ccot = function(a)
	return 1 / ctan(a)
end

local casin = function(a)
	return -1i * clog(1i * a + (1 - a ^ 2) ^ 0.5)
end

local cacos = function(a)
	return -1i * clog(a + 1i * (1 - a ^ 2) ^ 0.5)
end

local catan = function(a)
	return -1i / 2 * clog((1i - a) / (1i + a))
end

local cacot = function(a)
	return 1i / 2 * clog((a - 1i) / (a + 1i))
end

local csinh = function(a)
	return (cexp(a) - cexp(-a)) / 2
end

local ccosh = function(a)
	return (cexp(a) + cexp(-a)) / 2
end

local ctanh = function(a)
	return csinh(a) / ccosh(a)
end

local ccoth = function(a)
	return ccosh(a) / csinh(a)
end
--
local casinh = function(a)
	return 1i * casin(-1i * a)
end

local cacosh = function(a)
	return 1i * cacos(a)
end

local catanh = function(a)
	return 1i * catan(-1i * a)
end

local cacoth = function(a)
	return 1i * cacot(1i * a)
end

local conjugate = function(a)
	a = tocomplex(a)
	return complex(a[0], -a[1])
end

cmath.tocomplex = tocomplex
cmath.abs = cabs
cmath.arg = carg
cmath.npolar = cnpolar
cmath.cpolar = ccpolar
cmath.log = clog
cmath.exp = cexp
cmath.sin = csin
cmath.cos = ccos
cmath.tan = ctan
cmath.cot = ccot
cmath.asin = casin
cmath.acos = cacos
cmath.atan = catan
cmath.acot = cacot
cmath.sinh = csinh
cmath.cosh = ccosh
cmath.tanh = ctanh
cmath.coth = ccoth
cmath.asinh = casinh
cmath.acosh = cacosh
cmath.atanh = catanh
cmath.acoth = cacoth
cmath.conjugate = conjugate

mt.__index = function(_, key)
	return cmath[key]
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
	return cexp(b * clog(a))
end

cmath.complex = ffi.metatype(complex, mt)

local eps = 1e-12

assert(1i == 1i)
assert(1i ~= 2i)
assert(1i + 1i == 2i)
assert(1 + 2i == 2i + 1)
assert(1 - 2i == -(2i - 1))
assert(1 - 2i == -(2i - 1))
assert(cmath.conjugate(1 - 2i) == 1 + 2i)
assert(cmath.abs(cmath.exp(1i * math.pi) + 1) < eps)
assert(1i ^ 1i == math.exp(-pi / 2))
assert(cmath.abs(cmath.cpolar(1, math.pi / 2) - 1i) < eps)

local r, f = cmath.npolar(1 + 1i)
assert(math.abs(r - math.sqrt(2)) < 1e-12)
assert(math.abs(f - math.pi / 4) < 1e-12)

local z = 1 + 1i
assert(cmath.abs(cmath.asin(cmath.sin(z)) - z) < eps)
assert(cmath.abs(cmath.acos(cmath.cos(z)) - z) < eps)
assert(cmath.abs(cmath.atan(cmath.tan(z)) - z) < eps)
assert(cmath.abs(cmath.acot(cmath.cot(z)) - z) < eps)
assert(cmath.abs(cmath.asinh(cmath.sinh(z)) - z) < eps)
assert(cmath.abs(cmath.acosh(cmath.cosh(z)) - z) < eps)
assert(cmath.abs(cmath.atanh(cmath.tanh(z)) - z) < eps)
assert(cmath.abs(cmath.acoth(cmath.coth(z)) - z) < eps)

return cmath
