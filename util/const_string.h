#pragma once

#include <cassert>
#include <cstdio>

namespace desert {
namespace util {
constexpr size_t LenStr( const char * const str, size_t len = 0 )
{
    return *str ? LenStr( str+1, len+1 ) : len ;
}

template <size_t N>
constexpr __uint128_t _IntStr( const char * const str, __uint128_t base = 0 )
{
    static_assert( N <= 16, "超出字符串最大限制" ) ;
    return *str ? _IntStr<N-1>( str+1, ((__uint128_t)(unsigned char)(*str)) + (base << 8)) : base ;
}

template <>
constexpr __uint128_t _IntStr<0>( const char * const, __uint128_t base )
{
    return base;
}

#define IntStr( str ) _IntStr<LenStr(str)>(str)
} // util
} // desert
