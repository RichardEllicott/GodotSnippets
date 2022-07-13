// a canvas noise multishader collecting noise for demo purposes, add it to a ColorRect
//
// note that this is not likely effecient code with the swicth statement, it is intended as example only
//

shader_type canvas_item;

// Description : Array and textureless GLSL 2D/3D/4D simplex 
//               noise functions.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : stegu
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//               https://github.com/stegu/webgl-noise
// 

vec4 mod289_4(vec4 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float mod289(float x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute_4(vec4 x) {
    return mod289_4(((x * 34.0) + 1.0) * x);
}

float permute(float x) {
    return mod289(((x * 34.0) + 1.0) * x);
}

vec4 taylorInvSqrt_4(vec4 r) {
    return 2.79284291400159 - 1.85373472095314 * r;
}

float taylorInvSqrt(float r) {
    return 2.79284291400159 - 1.85373472095314 * r;
}

vec4 grad4(float j, vec4 ip) {
    vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
    vec4 p, s;

    p.xyz = floor(fract(vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
    p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
    s = vec4(lessThan(p, vec4(0.0)));
    p.xyz = p.xyz + (s.xyz * 2.0 - 1.0) * s.www;

    return p;
}

float snoise(vec4 v) {
    vec4 C = vec4(0.138196601125011, // (5 - sqrt(5))/20  G4
        0.276393202250021, // 2 * G4
        0.414589803375032, // 3 * G4
        -0.447213595499958); // -1 + 4 * G4

    // First corner
    vec4 i = floor(v + dot(v, vec4(0.309016994374947451))); //// (sqrt(5) - 1)/4
    vec4 x0 = v - i + dot(i, C.xxxx);

    // Other corners

    // Rank sorting originally contributed by Bill Licea-Kane, AMD (formerly ATI)
    vec4 i0;
    vec3 isX = step(x0.yzw, x0.xxx);
    vec3 isYZ = step(x0.zww, x0.yyz);
    //  i0.x = dot( isX, vec3( 1.0 ) );
    i0.x = isX.x + isX.y + isX.z;
    i0.yzw = 1.0 - isX;
    //  i0.y += dot( isYZ.xy, vec2( 1.0 ) );
    i0.y += isYZ.x + isYZ.y;
    i0.zw += 1.0 - isYZ.xy;
    i0.z += isYZ.z;
    i0.w += 1.0 - isYZ.z;

    // i0 now contains the unique values 0,1,2,3 in each channel
    vec4 i3 = clamp(i0, 0.0, 1.0);
    vec4 i2 = clamp(i0 - 1.0, 0.0, 1.0);
    vec4 i1 = clamp(i0 - 2.0, 0.0, 1.0);

    //  x0 = x0 - 0.0 + 0.0 * C.xxxx
    //  x1 = x0 - i1  + 1.0 * C.xxxx
    //  x2 = x0 - i2  + 2.0 * C.xxxx
    //  x3 = x0 - i3  + 3.0 * C.xxxx
    //  x4 = x0 - 1.0 + 4.0 * C.xxxx
    vec4 x1 = x0 - i1 + C.xxxx;
    vec4 x2 = x0 - i2 + C.yyyy;
    vec4 x3 = x0 - i3 + C.zzzz;
    vec4 x4 = x0 + C.wwww;

    // Permutations
    i = mod289_4(i);
    float j0 = permute(permute(permute(permute(i.w) + i.z) + i.y) + i.x);
    vec4 j1 = permute_4(permute_4(permute_4(permute_4(
                    i.w + vec4(i1.w, i2.w, i3.w, 1.0)) +
                i.z + vec4(i1.z, i2.z, i3.z, 1.0)) +
            i.y + vec4(i1.y, i2.y, i3.y, 1.0)) +
        i.x + vec4(i1.x, i2.x, i3.x, 1.0));

    // Gradients: 7x7x6 points over a cube, mapped onto a 4-cross polytope
    // 7*7*6 = 294, which is close to the ring size 17*17 = 289.
    vec4 ip = vec4(1.0 / 294.0, 1.0 / 49.0, 1.0 / 7.0, 0.0);

    vec4 p0 = grad4(j0, ip);
    vec4 p1 = grad4(j1.x, ip);
    vec4 p2 = grad4(j1.y, ip);
    vec4 p3 = grad4(j1.z, ip);
    vec4 p4 = grad4(j1.w, ip);

    // Normalise gradients
    vec4 norm = taylorInvSqrt_4(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;
    p4 *= taylorInvSqrt(dot(p4, p4));

    // Mix contributions from the five corners
    vec3 m0 = max(0.6 - vec3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), vec3(0.0));
    vec2 m1 = max(0.6 - vec2(dot(x3, x3), dot(x4, x4)), vec2(0.0));
    m0 = m0 * m0;
    m1 = m1 * m1;
    return 33.0 * (dot(m0 * m0, vec3(dot(p0, x0), dot(p1, x1), dot(p2, x2))) +
        dot(m1 * m1, vec2(dot(p3, x3), dot(p4, x4))));
}

// GLSL textureless classic 4D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise
//

//vec4 mod289(vec4 x) {
//	return x - floor(x * (1.0 / 289.0)) * 289.0;
//}

//vec4 permute(vec4 x) {
//	return mod289(((x*34.0)+1.0)*x);
//}

//vec4 taylorInvSqrt(vec4 r) {
//	return 1.79284291400159 - 0.85373472095314 * r;
//}

vec4 fade(vec4 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

// Classic Perlin noise
float cnoise(vec4 P) {
    vec4 Pi0 = floor(P); // Integer part for indexing
    vec4 Pi1 = Pi0 + 1.0; // Integer part + 1
    Pi0 = mod289_4(Pi0);
    Pi1 = mod289_4(Pi1);
    vec4 Pf0 = fract(P); // Fractional part for interpolation
    vec4 Pf1 = Pf0 - 1.0; // Fractional part - 1.0
    vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
    vec4 iy = vec4(Pi0.yy, Pi1.yy);
    vec4 iz0 = vec4(Pi0.zzzz);
    vec4 iz1 = vec4(Pi1.zzzz);
    vec4 iw0 = vec4(Pi0.wwww);
    vec4 iw1 = vec4(Pi1.wwww);

    vec4 ixy = permute_4(permute_4(ix) + iy);
    vec4 ixy0 = permute_4(ixy + iz0);
    vec4 ixy1 = permute_4(ixy + iz1);
    vec4 ixy00 = permute_4(ixy0 + iw0);
    vec4 ixy01 = permute_4(ixy0 + iw1);
    vec4 ixy10 = permute_4(ixy1 + iw0);
    vec4 ixy11 = permute_4(ixy1 + iw1);

    vec4 gx00 = ixy00 * (1.0 / 7.0);
    vec4 gy00 = floor(gx00) * (1.0 / 7.0);
    vec4 gz00 = floor(gy00) * (1.0 / 6.0);
    gx00 = fract(gx00) - 0.5;
    gy00 = fract(gy00) - 0.5;
    gz00 = fract(gz00) - 0.5;
    vec4 gw00 = vec4(0.75) - abs(gx00) - abs(gy00) - abs(gz00);
    vec4 sw00 = step(gw00, vec4(0.0));
    gx00 -= sw00 * (step(0.0, gx00) - 0.5);
    gy00 -= sw00 * (step(0.0, gy00) - 0.5);

    vec4 gx01 = ixy01 * (1.0 / 7.0);
    vec4 gy01 = floor(gx01) * (1.0 / 7.0);
    vec4 gz01 = floor(gy01) * (1.0 / 6.0);
    gx01 = fract(gx01) - 0.5;
    gy01 = fract(gy01) - 0.5;
    gz01 = fract(gz01) - 0.5;
    vec4 gw01 = vec4(0.75) - abs(gx01) - abs(gy01) - abs(gz01);
    vec4 sw01 = step(gw01, vec4(0.0));
    gx01 -= sw01 * (step(0.0, gx01) - 0.5);
    gy01 -= sw01 * (step(0.0, gy01) - 0.5);

    vec4 gx10 = ixy10 * (1.0 / 7.0);
    vec4 gy10 = floor(gx10) * (1.0 / 7.0);
    vec4 gz10 = floor(gy10) * (1.0 / 6.0);
    gx10 = fract(gx10) - 0.5;
    gy10 = fract(gy10) - 0.5;
    gz10 = fract(gz10) - 0.5;
    vec4 gw10 = vec4(0.75) - abs(gx10) - abs(gy10) - abs(gz10);
    vec4 sw10 = step(gw10, vec4(0.0));
    gx10 -= sw10 * (step(0.0, gx10) - 0.5);
    gy10 -= sw10 * (step(0.0, gy10) - 0.5);

    vec4 gx11 = ixy11 * (1.0 / 7.0);
    vec4 gy11 = floor(gx11) * (1.0 / 7.0);
    vec4 gz11 = floor(gy11) * (1.0 / 6.0);
    gx11 = fract(gx11) - 0.5;
    gy11 = fract(gy11) - 0.5;
    gz11 = fract(gz11) - 0.5;
    vec4 gw11 = vec4(0.75) - abs(gx11) - abs(gy11) - abs(gz11);
    vec4 sw11 = step(gw11, vec4(0.0));
    gx11 -= sw11 * (step(0.0, gx11) - 0.5);
    gy11 -= sw11 * (step(0.0, gy11) - 0.5);

    vec4 g0000 = vec4(gx00.x, gy00.x, gz00.x, gw00.x);
    vec4 g1000 = vec4(gx00.y, gy00.y, gz00.y, gw00.y);
    vec4 g0100 = vec4(gx00.z, gy00.z, gz00.z, gw00.z);
    vec4 g1100 = vec4(gx00.w, gy00.w, gz00.w, gw00.w);
    vec4 g0010 = vec4(gx10.x, gy10.x, gz10.x, gw10.x);
    vec4 g1010 = vec4(gx10.y, gy10.y, gz10.y, gw10.y);
    vec4 g0110 = vec4(gx10.z, gy10.z, gz10.z, gw10.z);
    vec4 g1110 = vec4(gx10.w, gy10.w, gz10.w, gw10.w);
    vec4 g0001 = vec4(gx01.x, gy01.x, gz01.x, gw01.x);
    vec4 g1001 = vec4(gx01.y, gy01.y, gz01.y, gw01.y);
    vec4 g0101 = vec4(gx01.z, gy01.z, gz01.z, gw01.z);
    vec4 g1101 = vec4(gx01.w, gy01.w, gz01.w, gw01.w);
    vec4 g0011 = vec4(gx11.x, gy11.x, gz11.x, gw11.x);
    vec4 g1011 = vec4(gx11.y, gy11.y, gz11.y, gw11.y);
    vec4 g0111 = vec4(gx11.z, gy11.z, gz11.z, gw11.z);
    vec4 g1111 = vec4(gx11.w, gy11.w, gz11.w, gw11.w);

    vec4 norm00 = taylorInvSqrt_4(vec4(dot(g0000, g0000), dot(g0100, g0100), dot(g1000, g1000), dot(g1100, g1100)));
    g0000 *= norm00.x;
    g0100 *= norm00.y;
    g1000 *= norm00.z;
    g1100 *= norm00.w;

    vec4 norm01 = taylorInvSqrt_4(vec4(dot(g0001, g0001), dot(g0101, g0101), dot(g1001, g1001), dot(g1101, g1101)));
    g0001 *= norm01.x;
    g0101 *= norm01.y;
    g1001 *= norm01.z;
    g1101 *= norm01.w;

    vec4 norm10 = taylorInvSqrt_4(vec4(dot(g0010, g0010), dot(g0110, g0110), dot(g1010, g1010), dot(g1110, g1110)));
    g0010 *= norm10.x;
    g0110 *= norm10.y;
    g1010 *= norm10.z;
    g1110 *= norm10.w;

    vec4 norm11 = taylorInvSqrt_4(vec4(dot(g0011, g0011), dot(g0111, g0111), dot(g1011, g1011), dot(g1111, g1111)));
    g0011 *= norm11.x;
    g0111 *= norm11.y;
    g1011 *= norm11.z;
    g1111 *= norm11.w;

    float n0000 = dot(g0000, Pf0);
    float n1000 = dot(g1000, vec4(Pf1.x, Pf0.yzw));
    float n0100 = dot(g0100, vec4(Pf0.x, Pf1.y, Pf0.zw));
    float n1100 = dot(g1100, vec4(Pf1.xy, Pf0.zw));
    float n0010 = dot(g0010, vec4(Pf0.xy, Pf1.z, Pf0.w));
    float n1010 = dot(g1010, vec4(Pf1.x, Pf0.y, Pf1.z, Pf0.w));
    float n0110 = dot(g0110, vec4(Pf0.x, Pf1.yz, Pf0.w));
    float n1110 = dot(g1110, vec4(Pf1.xyz, Pf0.w));
    float n0001 = dot(g0001, vec4(Pf0.xyz, Pf1.w));
    float n1001 = dot(g1001, vec4(Pf1.x, Pf0.yz, Pf1.w));
    float n0101 = dot(g0101, vec4(Pf0.x, Pf1.y, Pf0.z, Pf1.w));
    float n1101 = dot(g1101, vec4(Pf1.xy, Pf0.z, Pf1.w));
    float n0011 = dot(g0011, vec4(Pf0.xy, Pf1.zw));
    float n1011 = dot(g1011, vec4(Pf1.x, Pf0.y, Pf1.zw));
    float n0111 = dot(g0111, vec4(Pf0.x, Pf1.yzw));
    float n1111 = dot(g1111, Pf1);

    vec4 fade_xyzw = fade(Pf0);
    vec4 n_0w = mix(vec4(n0000, n1000, n0100, n1100), vec4(n0001, n1001, n0101, n1101), fade_xyzw.w);
    vec4 n_1w = mix(vec4(n0010, n1010, n0110, n1110), vec4(n0011, n1011, n0111, n1111), fade_xyzw.w);
    vec4 n_zw = mix(n_0w, n_1w, fade_xyzw.z);
    vec2 n_yzw = mix(n_zw.xy, n_zw.zw, fade_xyzw.y);
    float n_xyzw = mix(n_yzw.x, n_yzw.y, fade_xyzw.x);
    return 2.2 * n_xyzw;
}

// Classic Perlin noise, periodic version
float pnoise(vec4 P, vec4 rep) {
    vec4 Pi0 = mod(floor(P), rep); // Integer part modulo rep
    vec4 Pi1 = mod(Pi0 + 1.0, rep); // Integer part + 1 mod rep
    Pi0 = mod289_4(Pi0);
    Pi1 = mod289_4(Pi1);
    vec4 Pf0 = fract(P); // Fractional part for interpolation
    vec4 Pf1 = Pf0 - 1.0; // Fractional part - 1.0
    vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
    vec4 iy = vec4(Pi0.yy, Pi1.yy);
    vec4 iz0 = vec4(Pi0.zzzz);
    vec4 iz1 = vec4(Pi1.zzzz);
    vec4 iw0 = vec4(Pi0.wwww);
    vec4 iw1 = vec4(Pi1.wwww);

    vec4 ixy = permute_4(permute_4(ix) + iy);
    vec4 ixy0 = permute_4(ixy + iz0);
    vec4 ixy1 = permute_4(ixy + iz1);
    vec4 ixy00 = permute_4(ixy0 + iw0);
    vec4 ixy01 = permute_4(ixy0 + iw1);
    vec4 ixy10 = permute_4(ixy1 + iw0);
    vec4 ixy11 = permute_4(ixy1 + iw1);

    vec4 gx00 = ixy00 * (1.0 / 7.0);
    vec4 gy00 = floor(gx00) * (1.0 / 7.0);
    vec4 gz00 = floor(gy00) * (1.0 / 6.0);
    gx00 = fract(gx00) - 0.5;
    gy00 = fract(gy00) - 0.5;
    gz00 = fract(gz00) - 0.5;
    vec4 gw00 = vec4(0.75) - abs(gx00) - abs(gy00) - abs(gz00);
    vec4 sw00 = step(gw00, vec4(0.0));
    gx00 -= sw00 * (step(0.0, gx00) - 0.5);
    gy00 -= sw00 * (step(0.0, gy00) - 0.5);

    vec4 gx01 = ixy01 * (1.0 / 7.0);
    vec4 gy01 = floor(gx01) * (1.0 / 7.0);
    vec4 gz01 = floor(gy01) * (1.0 / 6.0);
    gx01 = fract(gx01) - 0.5;
    gy01 = fract(gy01) - 0.5;
    gz01 = fract(gz01) - 0.5;
    vec4 gw01 = vec4(0.75) - abs(gx01) - abs(gy01) - abs(gz01);
    vec4 sw01 = step(gw01, vec4(0.0));
    gx01 -= sw01 * (step(0.0, gx01) - 0.5);
    gy01 -= sw01 * (step(0.0, gy01) - 0.5);

    vec4 gx10 = ixy10 * (1.0 / 7.0);
    vec4 gy10 = floor(gx10) * (1.0 / 7.0);
    vec4 gz10 = floor(gy10) * (1.0 / 6.0);
    gx10 = fract(gx10) - 0.5;
    gy10 = fract(gy10) - 0.5;
    gz10 = fract(gz10) - 0.5;
    vec4 gw10 = vec4(0.75) - abs(gx10) - abs(gy10) - abs(gz10);
    vec4 sw10 = step(gw10, vec4(0.0));
    gx10 -= sw10 * (step(0.0, gx10) - 0.5);
    gy10 -= sw10 * (step(0.0, gy10) - 0.5);

    vec4 gx11 = ixy11 * (1.0 / 7.0);
    vec4 gy11 = floor(gx11) * (1.0 / 7.0);
    vec4 gz11 = floor(gy11) * (1.0 / 6.0);
    gx11 = fract(gx11) - 0.5;
    gy11 = fract(gy11) - 0.5;
    gz11 = fract(gz11) - 0.5;
    vec4 gw11 = vec4(0.75) - abs(gx11) - abs(gy11) - abs(gz11);
    vec4 sw11 = step(gw11, vec4(0.0));
    gx11 -= sw11 * (step(0.0, gx11) - 0.5);
    gy11 -= sw11 * (step(0.0, gy11) - 0.5);

    vec4 g0000 = vec4(gx00.x, gy00.x, gz00.x, gw00.x);
    vec4 g1000 = vec4(gx00.y, gy00.y, gz00.y, gw00.y);
    vec4 g0100 = vec4(gx00.z, gy00.z, gz00.z, gw00.z);
    vec4 g1100 = vec4(gx00.w, gy00.w, gz00.w, gw00.w);
    vec4 g0010 = vec4(gx10.x, gy10.x, gz10.x, gw10.x);
    vec4 g1010 = vec4(gx10.y, gy10.y, gz10.y, gw10.y);
    vec4 g0110 = vec4(gx10.z, gy10.z, gz10.z, gw10.z);
    vec4 g1110 = vec4(gx10.w, gy10.w, gz10.w, gw10.w);
    vec4 g0001 = vec4(gx01.x, gy01.x, gz01.x, gw01.x);
    vec4 g1001 = vec4(gx01.y, gy01.y, gz01.y, gw01.y);
    vec4 g0101 = vec4(gx01.z, gy01.z, gz01.z, gw01.z);
    vec4 g1101 = vec4(gx01.w, gy01.w, gz01.w, gw01.w);
    vec4 g0011 = vec4(gx11.x, gy11.x, gz11.x, gw11.x);
    vec4 g1011 = vec4(gx11.y, gy11.y, gz11.y, gw11.y);
    vec4 g0111 = vec4(gx11.z, gy11.z, gz11.z, gw11.z);
    vec4 g1111 = vec4(gx11.w, gy11.w, gz11.w, gw11.w);

    vec4 norm00 = taylorInvSqrt_4(vec4(dot(g0000, g0000), dot(g0100, g0100), dot(g1000, g1000), dot(g1100, g1100)));
    g0000 *= norm00.x;
    g0100 *= norm00.y;
    g1000 *= norm00.z;
    g1100 *= norm00.w;

    vec4 norm01 = taylorInvSqrt_4(vec4(dot(g0001, g0001), dot(g0101, g0101), dot(g1001, g1001), dot(g1101, g1101)));
    g0001 *= norm01.x;
    g0101 *= norm01.y;
    g1001 *= norm01.z;
    g1101 *= norm01.w;

    vec4 norm10 = taylorInvSqrt_4(vec4(dot(g0010, g0010), dot(g0110, g0110), dot(g1010, g1010), dot(g1110, g1110)));
    g0010 *= norm10.x;
    g0110 *= norm10.y;
    g1010 *= norm10.z;
    g1110 *= norm10.w;

    vec4 norm11 = taylorInvSqrt_4(vec4(dot(g0011, g0011), dot(g0111, g0111), dot(g1011, g1011), dot(g1111, g1111)));
    g0011 *= norm11.x;
    g0111 *= norm11.y;
    g1011 *= norm11.z;
    g1111 *= norm11.w;

    float n0000 = dot(g0000, Pf0);
    float n1000 = dot(g1000, vec4(Pf1.x, Pf0.yzw));
    float n0100 = dot(g0100, vec4(Pf0.x, Pf1.y, Pf0.zw));
    float n1100 = dot(g1100, vec4(Pf1.xy, Pf0.zw));
    float n0010 = dot(g0010, vec4(Pf0.xy, Pf1.z, Pf0.w));
    float n1010 = dot(g1010, vec4(Pf1.x, Pf0.y, Pf1.z, Pf0.w));
    float n0110 = dot(g0110, vec4(Pf0.x, Pf1.yz, Pf0.w));
    float n1110 = dot(g1110, vec4(Pf1.xyz, Pf0.w));
    float n0001 = dot(g0001, vec4(Pf0.xyz, Pf1.w));
    float n1001 = dot(g1001, vec4(Pf1.x, Pf0.yz, Pf1.w));
    float n0101 = dot(g0101, vec4(Pf0.x, Pf1.y, Pf0.z, Pf1.w));
    float n1101 = dot(g1101, vec4(Pf1.xy, Pf0.z, Pf1.w));
    float n0011 = dot(g0011, vec4(Pf0.xy, Pf1.zw));
    float n1011 = dot(g1011, vec4(Pf1.x, Pf0.y, Pf1.zw));
    float n0111 = dot(g0111, vec4(Pf0.x, Pf1.yzw));
    float n1111 = dot(g1111, Pf1);

    vec4 fade_xyzw = fade(Pf0);
    vec4 n_0w = mix(vec4(n0000, n1000, n0100, n1100), vec4(n0001, n1001, n0101, n1101), fade_xyzw.w);
    vec4 n_1w = mix(vec4(n0010, n1010, n0110, n1110), vec4(n0011, n1011, n0111, n1111), fade_xyzw.w);
    vec4 n_zw = mix(n_0w, n_1w, fade_xyzw.z);
    vec2 n_yzw = mix(n_zw.xy, n_zw.zw, fade_xyzw.y);
    float n_xyzw = mix(n_yzw.x, n_yzw.y, fade_xyzw.x);
    return 2.2 * n_xyzw;
}

// from godot orginal examples:
float hash(vec2 p) {
    return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}
float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    vec2 a = vec2(1.0, 0.0);
    return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x),
        mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 _x) {
    float _height = 0.0;
    float _amplitude = 0.5;
    float _frequency = 3.0;
    for (int i = 0; i < 6; i++) {
        _height += noise(_x * _frequency) * _amplitude;
        _amplitude *= 0.5;
        _frequency *= 2.0;
    }
    return _height;
}

float fbm_snoise(vec4 _x) {
    float _height = 0.0;
    float _amplitude = 0.5;
    float _frequency = 3.0;
    for (int i = 0; i < 6; i++) {
        _height += snoise(_x * _frequency) * _amplitude;
        _amplitude *= 0.5;
        _frequency *= 2.0;
    }
    return _height;
}

float fbm_cnoise(vec4 _x) {
    float _height = 0.0;
    float _amplitude = 0.5;
    float _frequency = 3.0;
    for (int i = 0; i < 6; i++) {
        _height += cnoise(_x * _frequency) * _amplitude;
        _amplitude *= 0.5;
        _frequency *= 2.0;
    }
    return _height;
}

// RIP FROM SHADERTOY:
// https://www.shadertoy.com/view/WdfyRl

// EXAMPLE:
// vec4 worley = worley(UV,TIME * time_scale);
// color_out = vec3(worley.xyz);

// for the worley function
vec2 random2(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)),
        dot(uv, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

vec4 worley(vec2 fragCoord, float iTime) {

    vec2 iResolution = vec2(1.0, 1.0);

    float cellNum = 10.;

    vec2 uv = fragCoord / iResolution.xy;

    uv.x *= iResolution.x / iResolution.y;

    uv *= cellNum;

    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float minDist = 1.;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));

            vec2 point = random2(i + neighbor);

            point = 0.5 + 0.5 * sin(iTime + 6.2831 * point);

            float dist = length(neighbor + point - f);

            minDist = min(minDist, dist);
        }
    }
    return vec4(vec3(minDist), 1.);
}

uniform vec2 offset;
uniform vec2 scale;

uniform float time_scale = 1.0;

uniform int mode = 0;

uniform bool use_gradient = false;
uniform sampler2D gradient;

void fragment() {

    float _time = TIME * time_scale;

    float height = 0.0;

    switch (mode) {
    case 0: // simplex noise
        height = snoise(vec4((UV + offset) * scale, 1.0, _time)) * 0.5 + 0.5;
        break;
    case 1: // perlin noise
        height = cnoise(vec4((UV + offset) * scale, 1.0, _time)) * 0.5 + 0.5;
        break;
    case 2: // simple fractal noise from godot examples
        height = fbm(UV + offset);
        break;
    case 3: // fractal simplex noise 
        height = fbm_snoise(vec4((UV + offset) * scale, 1.0, _time)) * 0.5 + 0.5;
        break;
    case 4: // fractal perlin noise
        height = fbm_cnoise(vec4((UV + offset) * scale, 1.0, _time)) * 0.5 + 0.5;
        break;
    case 5: // cellular
        //height = fbm_cnoise(vec4((UV + offset) * scale, 1.0, _time)) * 0.5 + 0.5;
        height = worley(UV * scale.xy, _time).x;
        break;
    }

    if (use_gradient) {
        COLOR.rgb = texture(gradient, vec2(height, 0.0)).xyz;
    } else {
        COLOR.rgb = vec3(height);
    }

}
