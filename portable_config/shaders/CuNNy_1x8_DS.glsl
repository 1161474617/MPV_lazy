// CuNNy 1x8 BILINEAR MPV NVL DS
// Copyright (c) 2024 cunnyplapper

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3.0 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this program.  If not, see <https://www.gnu.org/licenses/>.
/* ------------------------------------------------------------------- */


//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-DS-in
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND LUMA
//!SAVE in
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) F(LUMA_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(1, 1) + ivec2(0, 0)) + vec2(0.5)) * LUMA_pt).r)
shared F G[1][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
		}
	}
	barrier();
	F s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0, r1;
	r0 = V4(0.0); r1 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2];
	r0 += V4(1.049e-01, -2.151e-02, -4.227e-03, 6.274e-02) * s0_0_0;
	r1 += V4(1.616e-01, -1.053e-01, -4.107e-03, 6.665e-03) * s0_0_0;
	r0 += V4(-8.813e-02, 2.848e-02, 1.126e-02, 2.862e-01) * s0_0_1;
	r1 += V4(9.912e-02, 7.915e-01, -4.301e-02, -6.744e-02) * s0_0_1;
	r0 += V4(-4.652e-03, 2.292e-02, 1.960e-02, 8.964e-02) * s0_0_2;
	r1 += V4(-1.978e-01, 5.250e-03, 3.835e-02, 6.999e-02) * s0_0_2;
	r0 += V4(-7.241e-01, 2.145e-01, -9.360e-02, -8.859e-02) * s0_1_0;
	r1 += V4(1.785e-01, -8.805e-02, 2.955e-02, 3.066e-01) * s0_1_0;
	r0 += V4(3.178e-02, 3.957e-01, 1.101e-01, -5.478e-01) * s0_1_1;
	r1 += V4(-7.598e-01, -5.100e-01, -7.027e-01, -7.532e-01) * s0_1_1;
	r0 += V4(8.479e-02, -1.813e-02, -2.454e-02, -1.284e-01) * s0_1_2;
	r1 += V4(1.491e-01, -7.690e-02, 7.167e-01, -9.099e-02) * s0_1_2;
	r0 += V4(-6.834e-02, -2.094e-02, -2.624e-02, 2.125e-02) * s0_2_0;
	r1 += V4(-9.969e-02, 8.846e-03, -1.080e-02, 2.604e-03) * s0_2_0;
	r0 += V4(7.413e-01, 5.799e-03, 3.794e-01, 2.519e-01) * s0_2_1;
	r1 += V4(2.980e-01, -2.924e-02, 2.641e-02, 5.238e-01) * s0_2_1;
	r0 += V4(-8.081e-02, -5.652e-03, 1.040e-02, 6.032e-02) * s0_2_2;
	r1 += V4(1.584e-01, 2.925e-02, -2.875e-02, 1.502e-02) * s0_2_2;
	r0 += V4(3.106e-03, 1.590e-03, 5.137e-03, 8.094e-03);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(-9.195e-03, -2.537e-02, -2.788e-02, -1.788e-02);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-DS-conv1
//!HOOK LUMA
//!COMPUTE 16 8 8 8
//!BIND in
//!BIND LUMA
//!SAVE conv1
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h
//!COMPONENTS 4
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) V4(in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * in_pt))
#define l1(x, y) V4(in_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * in_pt))
shared V4 G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 1);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
			G[1][ay][ax] = l1(x - 1, y - 1);
		}
	}
	barrier();
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0, r1;
	r0 = V4(0.0); r1 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 += M4(-4.413e-02, 2.976e-02, -7.246e-02, 6.608e-02, 5.146e-02, 1.937e-01, 2.148e-02, 1.717e-01, 2.124e-01, 2.189e-01, 6.588e-01, 8.283e-02, 1.349e-02, 9.130e-03, -9.586e-02, 1.919e-01) * s0_0_0;
	r1 += M4(1.815e-01, -3.075e-01, -4.165e-02, 4.518e-02, -2.686e-01, 2.090e-01, -1.043e-01, 3.295e-02, -6.662e-02, -7.987e-01, -1.564e-01, 3.373e-02, -1.039e-01, 1.867e-01, -2.896e-02, -3.198e-02) * s0_0_0;
	r0 += M4(2.861e-01, 2.803e-01, 4.307e-01, 2.100e-01, 2.075e-01, -1.504e-01, -6.275e-02, 2.044e-01, -6.270e-01, -4.551e-01, -7.449e-01, -7.280e-01, 1.396e-01, 2.682e-01, 2.536e-01, -1.005e-01) * s0_0_1;
	r1 += M4(1.169e+00, -1.519e-01, 8.517e-02, 2.748e-01, 1.482e-01, 4.087e-01, 1.530e-01, -1.113e-01, -1.605e+00, -6.001e-02, 9.233e-02, 3.576e-02, 6.484e-02, -1.807e-01, -8.100e-03, 1.146e-02) * s0_0_1;
	r0 += M4(1.509e-01, -1.893e-02, 3.552e-02, 2.138e-01, 2.989e-01, -9.935e-02, 7.943e-02, 3.990e-01, -4.983e-01, 3.271e-01, -6.783e-02, -4.756e-01, 1.275e-01, 1.444e-01, 7.834e-02, 1.382e-01) * s0_0_2;
	r1 += M4(4.838e-01, 1.140e-01, 2.079e-01, -7.397e-02, -8.075e-02, -1.022e-01, -2.618e-02, -2.925e-01, -2.555e-01, 9.573e-02, -5.931e-02, 4.300e-01, 1.118e-01, -3.528e-02, -5.621e-02, 1.174e-01) * s0_0_2;
	r0 += M4(-2.463e-03, 1.478e-01, -1.121e-02, -8.618e-02, 2.063e-01, 5.247e-01, 3.223e-01, -1.753e-01, 3.469e-01, -1.275e-01, 3.697e-01, -8.590e-02, 2.397e-01, 5.165e-02, 2.564e-01, -1.645e-02) * s0_1_0;
	r1 += M4(1.387e-01, -1.507e-01, 4.354e-02, -6.165e-02, 3.486e-01, -2.607e-01, 2.007e-01, 2.073e-01, 1.594e-01, 6.149e-01, 7.869e-02, -8.166e-03, 2.153e-01, -5.773e-02, -1.903e-02, 1.687e-01) * s0_1_0;
	r0 += M4(4.365e-01, 7.007e-01, 6.699e-01, -2.231e-01, -2.389e-01, -7.520e-01, -2.234e-01, -5.611e-01, -5.256e-01, 1.627e-01, -1.657e-01, 5.012e-01, -6.730e-01, -8.728e-01, -8.784e-02, -7.787e-01) * s0_1_1;
	r1 += M4(5.138e-01, 3.117e-01, -6.243e-02, -3.070e-02, -1.187e+00, 3.817e-03, 6.066e-01, -1.903e-01, -4.385e-01, -2.075e-01, 2.771e-02, -3.711e-01, -4.375e-01, 2.717e-02, 1.348e-01, 3.821e-01) * s0_1_1;
	r0 += M4(-4.471e-02, 5.815e-01, 5.134e-01, 1.353e-01, -4.222e-02, 2.671e-01, 1.526e-02, -4.281e-01, 4.436e-01, -2.881e-01, -1.114e-01, 1.430e-01, -4.724e-02, 1.040e-01, 1.718e-02, -7.456e-02) * s0_1_2;
	r1 += M4(1.037e+00, 6.451e-02, 1.255e-01, 1.571e-02, -1.185e+00, -8.709e-02, 1.014e-01, -5.911e-02, -1.571e-01, 6.052e-01, 6.918e-02, 2.865e-01, 2.411e-01, 8.855e-02, -7.115e-02, 4.420e-02) * s0_1_2;
	r0 += M4(1.672e-02, 8.626e-02, 9.793e-03, -8.764e-02, 2.742e-01, 5.184e-01, 5.641e-01, 1.503e-04, 9.595e-02, -1.946e-02, 1.929e-01, 1.837e-01, 2.535e-01, 2.783e-01, 2.540e-01, -3.978e-01) * s0_2_0;
	r1 += M4(1.374e-01, -1.354e-01, -1.547e-02, -1.111e-03, 1.556e-01, 3.348e-01, -3.832e-02, 2.739e-02, -1.988e-01, 7.092e-02, 8.984e-03, 3.968e-02, -3.290e-02, 5.996e-01, -1.460e-02, -1.149e-01) * s0_2_0;
	r0 += M4(1.067e-01, 2.086e-02, 2.188e-01, -1.411e-01, -2.397e-01, -1.570e-01, -6.357e-01, 3.663e-01, -7.440e-02, -9.284e-03, -2.305e-01, -2.773e-02, -3.568e-01, 3.930e-01, 4.348e-01, 7.575e-01) * s0_2_1;
	r1 += M4(9.301e-02, 9.354e-02, 2.597e-02, 3.332e-02, -1.144e+00, -4.073e-01, -4.788e-03, 1.120e-01, -1.774e-01, -2.078e-01, 1.935e-02, -4.195e-02, -1.351e-02, -4.855e-02, -8.985e-03, 1.105e-01) * s0_2_1;
	r0 += M4(-4.356e-02, 2.866e-02, 3.246e-02, 1.091e-02, -1.476e-01, -2.328e-01, -1.117e-02, 2.770e-01, -1.876e-02, 3.556e-02, -2.671e-02, -4.467e-02, 5.188e-01, -1.713e-01, -1.159e-01, 8.562e-02) * s0_2_2;
	r1 += M4(1.998e-01, 1.286e-01, 1.636e-02, 7.766e-03, -9.392e-01, -2.718e-01, -3.731e-02, -7.450e-02, -6.348e-01, 5.370e-02, -3.902e-02, 4.056e-02, 2.151e-02, 5.048e-03, 8.635e-02, 3.940e-02) * s0_2_2;
	r0 += M4(3.454e-02, 1.127e-04, 1.917e-02, -6.618e-02, -7.883e-02, -1.882e-01, -1.150e-01, -3.942e-02, -2.215e-02, -7.655e-02, -1.598e-01, -7.619e-02, -1.248e-01, -2.892e-01, -2.280e-01, -2.498e-02) * s1_0_0;
	r1 += M4(2.255e-02, -3.144e-01, 4.451e-02, -2.897e-01, 5.118e-02, -8.630e-02, -4.600e-03, 1.919e-01, 6.882e-02, 5.171e-02, -1.706e-02, -7.206e-02, 1.136e-01, 2.871e-01, -1.586e-01, 3.764e-01) * s1_0_0;
	r0 += M4(-1.143e-01, -1.228e-01, -2.355e-01, -1.605e-01, -6.416e-02, -1.652e-01, -2.354e-01, -3.213e-02, 9.598e-02, 5.835e-02, -1.445e-02, -1.595e-03, -1.514e-01, -3.428e-01, -3.505e-01, 1.267e-01) * s1_0_1;
	r1 += M4(-1.201e-01, -1.858e-01, -9.362e-02, -3.426e-01, 7.148e-02, 1.068e-02, 2.798e-02, 4.873e-01, 3.097e-02, 1.381e-02, 1.197e-01, 4.669e-01, 4.281e-01, 3.531e-01, 3.869e-02, 7.790e-01) * s1_0_1;
	r0 += M4(3.791e-03, 5.572e-02, 1.360e-01, 5.736e-02, -1.138e-01, -1.253e-02, -4.847e-02, -4.212e-02, 6.433e-02, -4.519e-02, 5.070e-02, 1.454e-03, -1.575e-01, -1.029e-01, 9.565e-02, 1.870e-01) * s1_0_2;
	r1 += M4(-7.231e-02, -2.427e-01, -2.807e-02, -5.876e-02, 3.468e-02, -7.799e-03, 3.645e-02, 5.828e-02, -1.665e-02, -5.357e-02, -1.860e-02, -3.742e-02, 3.403e-02, 7.353e-02, 1.671e-01, -1.645e-01) * s1_0_2;
	r0 += M4(-9.007e-02, 2.588e-02, 3.689e-01, 5.062e-02, 9.704e-03, 8.183e-02, -4.325e-01, 7.695e-02, 8.069e-04, -4.795e-02, -7.938e-01, -1.362e-01, -5.227e-04, -2.850e-01, -6.463e-01, -3.216e-01) * s1_1_0;
	r1 += M4(7.459e-02, -8.305e-01, 1.097e-01, -6.814e-02, 5.912e-02, -5.542e-03, 1.821e-01, -9.549e-02, 4.953e-02, 4.318e-01, 7.023e-02, 1.175e-01, 9.204e-02, 8.440e-01, -1.864e-02, -2.378e-01) * s1_1_0;
	r0 += M4(-3.433e-01, -1.165e-01, -5.537e-01, -8.610e-01, 7.974e-01, 6.522e-01, 5.180e-01, 7.829e-01, 5.526e-01, 2.853e-01, 4.331e-01, 7.793e-01, 1.527e-01, 1.512e-01, 3.431e-01, 7.945e-01) * s1_1_1;
	r1 += M4(1.009e-01, -3.805e-01, -3.459e-01, -6.934e-01, 5.879e-01, -4.415e-01, 3.910e-01, -4.346e-01, 9.727e-01, -5.137e-01, 3.054e-01, 4.240e-01, 1.348e+00, -3.464e-01, 3.218e-02, 3.900e-01) * s1_1_1;
	r0 += M4(-5.213e-02, 2.170e-01, 2.396e-01, -7.031e-02, 5.059e-01, 9.804e-02, -1.225e-01, 1.720e-01, 3.740e-01, -1.432e-01, -1.440e-01, -9.448e-02, 3.163e-01, -5.566e-01, -4.471e-01, -1.682e-01) * s1_1_2;
	r1 += M4(-1.226e-01, -2.218e-01, -1.720e-02, -6.483e-02, 1.411e-01, -1.326e-01, 1.343e-01, 3.564e-01, 1.140e-01, 2.878e-02, -2.942e-03, 1.563e-02, 3.138e-01, 2.529e-01, 1.218e-01, -6.263e-02) * s1_1_2;
	r0 += M4(-4.716e-02, 2.354e-02, 9.993e-03, 4.027e-01, 2.114e-01, 1.912e-01, 4.493e-01, 1.421e-01, -5.516e-02, 2.639e-01, 2.939e-01, -2.764e-01, -5.148e-02, -2.782e-01, -3.990e-01, -1.620e-01) * s1_2_0;
	r1 += M4(-2.225e-01, -1.092e+00, 6.310e-03, 7.150e-02, 3.277e-02, -3.072e-01, -1.140e-02, 1.707e-01, 1.490e-03, 1.647e-01, 2.884e-02, 6.661e-02, 9.559e-02, 2.633e-02, 4.403e-03, -5.973e-02) * s1_2_0;
	r0 += M4(3.772e-01, 5.033e-01, 1.653e-01, -1.621e-01, -2.617e-02, -1.332e+00, -9.391e-01, -1.246e+00, -1.800e-01, -8.363e-01, -5.131e-01, 9.083e-03, -2.399e-01, -4.914e-01, -2.589e-01, -2.494e-01) * s1_2_1;
	r1 += M4(-7.289e-02, -8.168e-01, -3.922e-02, -1.401e-01, 1.117e-01, 4.032e-01, 7.444e-02, -1.948e-01, -1.012e-01, 7.803e-02, -2.010e-02, 2.612e-02, 1.548e-01, 6.594e-01, 1.150e-02, -4.017e-02) * s1_2_1;
	r0 += M4(-2.708e-01, 1.499e-01, 1.790e-01, -7.248e-02, -3.176e-01, -3.192e-01, -2.054e-01, 8.341e-02, 1.519e-01, -1.518e-01, -1.560e-01, 9.876e-02, -1.114e-01, -3.213e-01, -2.877e-01, -7.472e-02) * s1_2_2;
	r1 += M4(4.449e-02, -3.461e-01, -3.091e-02, -5.674e-02, -1.336e-02, 6.115e-03, -4.365e-02, 6.908e-02, 6.668e-02, -1.632e-02, 2.573e-02, -5.809e-03, 3.311e-01, 3.605e-01, 2.488e-02, 2.496e-02) * s1_2_2;
	r0 += V4(-4.068e-03, -3.406e-02, -4.419e-02, 3.338e-04);
	r0 = max(r0, V4(0.0));
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0));
	r1 += V4(5.833e-02, -1.409e-02, -5.228e-01, -7.814e-03);
	r1 = max(r1, V4(0.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r1));
}

//!DESC CuNNy-1x8-BILINEAR-MPV-NVL-DS-out-shuffle
//!HOOK LUMA
//!COMPUTE 16 16 8 8
//!BIND conv1
//!BIND LUMA
//!WIDTH LUMA.w 2 *
//!HEIGHT LUMA.h 2 *
//!COMPONENTS 1
//!WHEN OUTPUT.w LUMA.w / 1.2 > OUTPUT.h LUMA.h / 1.2 > *
#extension GL_EXT_shader_explicit_arithmetic_types_float16 : enable
#ifdef GL_EXT_shader_explicit_arithmetic_types_float16
#	define V4 f16vec4
#	define M4 f16mat4
#	define F float16_t
#else
#	define V4 vec4
#	define M4 mat4
#	define F float
#endif
#define l0(x, y) V4(conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(0, 0)) + vec2(0.5)) * conv1_pt))
#define l1(x, y) V4(conv1_tex((vec2(clamp(pos + ivec2(x, y), ivec2(0), sz) * ivec2(2, 1) + ivec2(1, 0)) + vec2(0.5)) * conv1_pt))
shared V4 G[2][10][10];
void hook() {
	ivec2 xy = ivec2(gl_LocalInvocationID.xy);
	ivec2 pos = ivec2(gl_WorkGroupID.xy) * ivec2(8, 8) + xy;
	ivec2 opos = pos * ivec2(2, 2);
	ivec2 sz = ivec2(LUMA_size) - ivec2(1);
	for (int y = 0; y < 10; y += 8) {
		int ay = xy.y + y;
		if (ay >= 10) break;
		for (int x = 0; x < 10; x += 8) {
			int ax = xy.x + x;
			if (ax >= 10) break;
			G[0][ay][ax] = l0(x - 1, y - 1);
			G[1][ay][ax] = l1(x - 1, y - 1);
		}
	}
	barrier();
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0;
	r0 = V4(0.0);
	s0_0_0 = G[0][xy.y+0][xy.x+0]; s0_0_1 = G[0][xy.y+0][xy.x+1];
	s0_0_2 = G[0][xy.y+0][xy.x+2]; s0_1_0 = G[0][xy.y+1][xy.x+0];
	s0_1_1 = G[0][xy.y+1][xy.x+1]; s0_1_2 = G[0][xy.y+1][xy.x+2];
	s0_2_0 = G[0][xy.y+2][xy.x+0]; s0_2_1 = G[0][xy.y+2][xy.x+1];
	s0_2_2 = G[0][xy.y+2][xy.x+2]; s1_0_0 = G[1][xy.y+0][xy.x+0];
	s1_0_1 = G[1][xy.y+0][xy.x+1]; s1_0_2 = G[1][xy.y+0][xy.x+2];
	s1_1_0 = G[1][xy.y+1][xy.x+0]; s1_1_1 = G[1][xy.y+1][xy.x+1];
	s1_1_2 = G[1][xy.y+1][xy.x+2]; s1_2_0 = G[1][xy.y+2][xy.x+0];
	s1_2_1 = G[1][xy.y+2][xy.x+1]; s1_2_2 = G[1][xy.y+2][xy.x+2];
	r0 += M4(-1.489e-01, 6.567e-02, 3.157e-02, 4.051e-02, -1.568e-02, -2.252e-02, -3.232e-02, -2.118e-03, 8.827e-02, -6.909e-02, -2.190e-02, -4.012e-02, 3.672e-02, 5.924e-02, -6.292e-02, -1.146e-02) * s0_0_0;
	r0 += M4(-1.333e-01, -3.947e-01, 6.141e-02, 5.421e-03, 2.220e-01, 3.270e-01, -4.135e-02, -2.648e-02, -2.313e-01, -8.857e-03, 6.567e-02, -1.804e-02, 2.036e-01, 1.996e-01, -1.401e-01, -1.218e-01) * s0_0_1;
	r0 += M4(3.598e-03, 2.070e-02, 8.423e-03, 3.094e-02, 1.509e-01, -9.446e-02, 6.323e-02, -3.901e-02, -5.352e-02, 9.625e-02, 4.927e-02, 1.194e-01, -8.327e-02, -5.481e-02, -3.573e-02, -7.984e-02) * s0_0_2;
	r0 += M4(1.161e-01, 1.552e-01, -4.349e-01, 1.705e-02, 8.310e-02, -6.048e-02, 2.328e-01, -1.208e-02, -1.613e-01, -6.604e-02, 1.284e-01, -2.585e-02, -6.222e-02, 7.735e-02, 4.576e-02, 1.223e-01) * s0_1_0;
	r0 += M4(1.145e-01, 1.587e-01, -1.716e-02, -4.014e-01, -7.207e-01, -1.788e-02, -1.428e-01, 7.535e-01, 6.102e-01, -2.187e-01, -2.357e-01, -4.647e-01, -9.077e-02, -7.921e-01, 7.975e-01, 8.802e-02) * s0_1_1;
	r0 += M4(1.220e-02, 1.274e-02, -6.087e-03, -4.098e-03, 1.392e-01, -3.561e-01, 1.694e-01, -4.381e-01, -6.145e-02, 4.765e-01, -7.155e-02, 3.857e-01, -1.681e-01, 1.548e-01, -1.342e-01, 2.881e-01) * s0_1_2;
	r0 += M4(-3.101e-03, -1.752e-02, 1.910e-01, 9.256e-02, 1.204e-01, 2.619e-02, -3.578e-02, -1.333e-01, -1.042e-01, 2.142e-02, -1.214e-01, 3.342e-02, 3.150e-02, 3.976e-02, 3.510e-02, -5.777e-03) * s0_2_0;
	r0 += M4(-2.841e-04, -7.597e-03, 9.593e-02, 1.687e-01, 2.249e-02, 7.326e-02, -1.317e-01, -1.084e-01, -6.235e-02, -8.079e-02, 2.200e-01, 3.886e-02, 1.674e-01, 2.636e-02, 3.948e-02, -4.895e-02) * s0_2_1;
	r0 += M4(-4.991e-03, 2.036e-03, -4.499e-03, 1.310e-02, -1.510e-02, 1.078e-02, -1.305e-02, 1.665e-02, 5.015e-03, -4.922e-02, -2.436e-02, -6.388e-03, -1.254e-02, 9.590e-02, -1.052e-01, 1.134e-02) * s0_2_2;
	r0 += M4(-4.259e-02, 8.771e-02, 6.758e-02, 2.217e-02, 4.674e-03, -4.941e-02, 3.085e-02, -4.030e-02, -6.939e-02, -1.355e-02, -1.462e-02, 7.146e-02, 1.217e-02, 1.850e-05, -3.673e-05, -2.672e-03) * s1_0_0;
	r0 += M4(-2.630e-01, -2.783e-01, 8.639e-02, 7.143e-02, -5.006e-01, 1.072e-01, 9.301e-02, 1.033e-01, -5.243e-02, -1.004e-01, 2.117e-02, -7.160e-02, -2.484e-02, 1.169e-02, -4.928e-03, 3.800e-04) * s1_0_1;
	r0 += M4(6.371e-02, -7.604e-02, 1.758e-03, 5.336e-02, 2.456e-01, -2.535e-01, 1.294e-01, 2.920e-01, 2.056e-02, 1.112e-01, -6.468e-03, 6.151e-02, 5.409e-03, -1.977e-02, 4.969e-03, -2.209e-03) * s1_0_2;
	r0 += M4(-3.136e-01, 5.105e-02, -2.666e-01, 9.692e-02, -5.210e-02, -8.686e-03, -5.284e-02, -2.020e-02, 1.389e+00, -1.015e-01, 4.335e-01, -8.816e-02, 1.860e-01, -3.650e-02, 4.020e-02, 1.275e-02) * s1_1_0;
	r0 += M4(-8.258e-01, -7.911e-01, -7.734e-01, -8.255e-01, 1.458e-01, -1.187e-02, -2.428e-01, 1.715e-01, 1.043e+00, 2.777e+00, 9.257e-02, 6.993e-01, -4.144e-02, 6.650e-02, 4.557e-02, 5.287e-02) * s1_1_1;
	r0 += M4(9.509e-02, -1.919e-01, 1.150e-01, -2.415e-01, 2.085e-01, 1.221e-01, 4.297e-02, -5.472e-01, -5.360e-02, 3.194e-02, 1.110e-03, -1.893e-02, 1.814e-01, 3.138e-01, 9.796e-03, 5.386e-02) * s1_1_2;
	r0 += M4(4.805e-02, -1.639e-02, -6.904e-02, 4.032e-02, 4.660e-03, 4.133e-03, -1.391e-02, -1.724e-02, -5.127e-02, -3.906e-02, 9.087e-01, -6.599e-02, 1.255e-01, -5.759e-02, 3.467e-01, -2.986e-02) * s1_2_0;
	r0 += M4(6.790e-02, 7.116e-02, -2.212e-01, -2.702e-01, -2.986e-02, -1.083e-02, -2.600e-02, -1.344e-02, 1.695e-01, 3.558e-01, 7.847e-01, 1.805e+00, -4.426e-01, 2.072e-01, -7.751e-01, -5.554e-02) * s1_2_1;
	r0 += M4(4.567e-03, 4.059e-02, 5.903e-02, -1.297e-02, -3.870e-02, -3.845e-02, 6.531e-02, 4.209e-02, -5.991e-02, -1.425e-01, -3.625e-02, 1.505e-02, 1.316e-02, -3.505e-01, 1.273e-01, -1.370e-01) * s1_2_2;
	r0 += V4(-1.338e-08, -1.449e-08, -1.441e-08, -1.283e-08);
	r0 = tanh(r0);
	vec2 opt = 0.5 * LUMA_pt;
	vec2 fpos = (vec2(opos) + vec2(0.5)) * opt;
	imageStore(out_image, opos + ivec2(0, 0), vec4(r0.x + LUMA_tex(fpos + vec2(0.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 0), vec4(r0.y + LUMA_tex(fpos + vec2(1.0, 0.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(0, 1), vec4(r0.z + LUMA_tex(fpos + vec2(0.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
	imageStore(out_image, opos + ivec2(1, 1), vec4(r0.w + LUMA_tex(fpos + vec2(1.0, 1.0) * opt).r, 0.0, 0.0, 1.0));
}