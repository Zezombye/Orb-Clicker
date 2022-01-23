
#!defineMember mantissa x
#!defineMember exponent y

#!define formatNb(nb) ("{}{}".format((nb).mantissa * 1000 if (nb).exponent == 3 and (nb).mantissa < 10 else (nb).mantissa, "" if (nb).exponent == 3 and (nb).mantissa < 10 else suffixes[(nb).exponent/3]))

#!define isLessThanOrEqual(a, b) ((a).exponent < (b).exponent or (a).exponent == (b).exponent and (a).mantissa <= (b).mantissa)

#!define add(a, b) vect(((a).mantissa + (b).mantissa * 10 ** ((b).exponent - (a).exponent)) / (1000 if ((a).mantissa + (b).mantissa * 10 ** ((b).exponent - (a).exponent)) >= 1000 else 1), (a).exponent + 3 * (((a).mantissa + (b).mantissa * 10 ** ((b).exponent - (a).exponent)) >= 1000), 0)
#(a) = vect((a).mantissa + (b).mantissa * 10 ** ((b).exponent - (a).exponent), (a).exponent, 0) \
#if (a).mantissa >= 1000: \
#    (a) = vect((a).mantissa / 1000, (a).exponent+3, 0)

#!define subtract(a, b) vect(((a).mantissa - (b).mantissa * 10 ** ((b).exponent - (a).exponent)) * (1000 if ((a).mantissa - (b).mantissa * 10 ** ((b).exponent - (a).exponent)) < 1 and (a).exponent > 1 else 1), (a).exponent - 3 * (((a).mantissa - (b).mantissa * 10 ** ((b).exponent - (a).exponent)) < 1 and (a).exponent > 1), 0)
#(a) = vect((a).mantissa - (b).mantissa * 10 ** ((b).exponent - (a).exponent), (a).exponent, 0) \
#if (a).mantissa < 1 and (a).exponent > 1: \
#    (a) = vect((a).mantissa * 1000, (a).exponent-3, 0)

#!define multiplyBySmallNb(a, b) vect((a).mantissa * (b) * (1000 if (a).mantissa * (b) < 1 and (a).exponent > 1 else 0.001 if (a).mantissa * (b) >= 1000 else 1), (a).exponent + (-3 if (a).mantissa * (b) < 1 and (a).exponent > 1 else 3 if (a).mantissa * (b) >= 1000 else 0), 0)
#(a) = vect((a).mantissa * (b), (a).exponent, 0) \
#if (a).mantissa >= 1000: \
#    (a) = vect((a).mantissa / 1000, (a).exponent+3, 0) \
#elif (a).mantissa < 1 and (a).exponent > 1: \
#    (a) = vect((a).mantissa * 1000, (a).exponent-3, 0)

#!define multiply(a, b) vect((a).mantissa * (b).mantissa * (1000 if (a).mantissa * (b).mantissa < 1 and (a).exponent + (b).exponent > 1 else 0.001 if (a).mantissa * (b).mantissa >= 1000 else 1), (a).exponent + (b).exponent + (-3 if (a).mantissa * (b).mantissa < 1 and (a).exponent + (b).exponent > 1 else 3 if (a).mantissa * (b).mantissa >= 1000 else 0), 0)
#(a) = vect((a).mantissa * (b).mantissa, (a).exponent + (b).exponent, 0) \
#if (a).mantissa >= 1000: \
#    (a) = vect((a).mantissa / 1000, (a).exponent+3, 0) \
#elif (a).mantissa < 1 and (a).exponent > 1: \
#    (a) = vect((a).mantissa * 1000, (a).exponent-3, 0)

#!define divide(a, b) vect((a).mantissa / (b).mantissa * (1 if (a).exponent >= (b).exponent else 10 ** ((a).exponent-(b).exponent)), max((a).exponent-(b).exponent, 0), 0)

#!define toSmallNb(x) ((x).mantissa * 10 ** (x).exponent)
