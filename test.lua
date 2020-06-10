local cmath = require("init")
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local atan2 = math.atan2
local log = math.log
local exp = math.exp
local pi = math.pi

local eps = 1e-12
local equals = function(a, b)
	assert(a)
	assert(b)
	return assert(cmath.abs(a - b) < eps)
end
local notequals = function(a, b)
	assert(a)
	assert(b)
	return assert(cmath.abs(a - b) >= eps)
end

assert(cmath.iscomplex(1i))
assert(cmath.iscomplex(1 + 1i))
assert(not cmath.iscomplex(1))
assert(tostring(1+1i) == "1+1i")
assert((1 + 1i) .. (2 + 2i) == "1+1i2+2i")
assert((1 + 1i):copy() == 1 + 1i)
assert((1 + 1i):sqrt() == (1 + 1i) ^ 0.5)

equals(-1, 1i * {0, 1})
equals(-1, {sqrt(2) / 2, sqrt(2) / 2} * cmath.exp(3i * pi / 4))

assert(1i == 1i)
assert(1i ~= 2i)
assert(1i + 1i == 2i)
assert(1 + 2i == 2i + 1)
assert(1 - 2i == -(2i - 1))
assert(1 - 2i == -(2i - 1))
assert((1 - 2i):conj() == 1 + 2i)

equals(cmath.sqrt(-1), 1i)
equals((1i * pi):exp(), -1)
equals(1i ^ 1i, exp(-pi / 2))
equals(cmath.complexpolar(1, pi / 2), 1i)

local r, t = (1 + 1i):polar()
equals(r, sqrt(2))
equals(t, pi / 4)

local z = 1 + 1i
equals(z, z:sin():asin())
equals(z, z:cos():acos())
equals(z, z:tan():atan())
equals(z, z:cot():acot())
equals(z, z:sinh():asinh())
equals(z, z:cosh():acosh())
equals(z, z:tanh():atanh())
equals(z, z:coth():acoth())

local z = 1 - 2i
equals(z, z:sin():asin())
equals(z, z:cos():acos())
equals(z, z:tan():atan())
equals(z, z:cot():acot())
equals(-z - pi * 1i, z:sinh():asinh())
equals(z, z:cosh():acosh(0, 1))
equals(z + pi * 1i, z:tanh():atanh())
equals(z + pi * 1i, z:coth():acoth())

local k1, k2 = 123, 456
equals(z, z:sin():asin(k1, k2):sin():asin())
equals(z, z:cos():acos(k1, k2):cos():acos())
equals(z, z:tan():atan(k1):tan():atan())
equals(z, z:cot():acot(k1):cot():acot())
equals(-z - pi * 1i, z:sinh():asinh(k1, k2):sinh():asinh())
equals(z, z:cosh():acosh(k1, k2):cosh():acosh(0, 1))
equals(z + pi * 1i, z:tanh():atanh(k1):tanh():atanh())
equals(z + pi * 1i, z:coth():acoth(k1):coth():acoth())

equals((1i):pow(2), -1)

local z = -1 + 0i
equals(z:pow(1 / 4, 0), 2 ^ 0.5 / 2 * (1 + 1i))
equals(z:pow(1 / 4, 1), 2 ^ 0.5 / 2 * (-1 + 1i))
equals(z:pow(1 / 4, 2), 2 ^ 0.5 / 2 * (-1 - 1i))
equals(z:pow(1 / 4, 3), 2 ^ 0.5 / 2 * (1 - 1i))
equals(z:pow(1 / 4, 0):pow(4), z)
equals(z:pow(1 / 4, 1):pow(4), z)
equals(z:pow(1 / 4, 2):pow(4), z)
equals(z:pow(1 / 4, 3):pow(4), z)

math.randomseed(os.time())
assert(cmath.random():abs() <= 1)

print("OK")
