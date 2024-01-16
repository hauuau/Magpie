// Generated by ravu-zoom.py
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!MAGPIE EFFECT
//!VERSION 4

//!TEXTURE
Texture2D INPUT;

//!SAMPLER
//!FILTER POINT
SamplerState sam_INPUT;

//!TEXTURE
//
//
Texture2D OUTPUT;

//!SAMPLER
//!FILTER LINEAR
SamplerState sam_INPUT_LINEAR;

//!TEXTURE
//!SOURCE ravu_zoom_lut3_f16.dds
//!FORMAT R16G16B16A16_FLOAT
Texture2D ravu_zoom_lut3;

//!SAMPLER
//!FILTER LINEAR
SamplerState sam_ravu_zoom_lut3;

//!COMMON
#include "prescalers.hlsli"

#define LAST_PASS 1

//!PASS 1
//!DESC RAVU-Zoom (luma, r3, compute)
//!IN INPUT, ravu_zoom_lut3
//!OUT OUTPUT
//!BLOCK_SIZE 32, 8
//!NUM_THREADS 32, 8
#define LUTPOS(x, lut_size) mix(0.5 / (lut_size), 1.0 - 0.5 / (lut_size), (x))
shared float samples[532];

#define CURRENT_PASS 1

#define GET_SAMPLE(x) dot(x.rgb, rgb2y)
#define imageStore(out_image, pos, val) imageStoreOverride(pos, val.x)
void imageStoreOverride(uint2 pos, float value) {
	float2 UV = mul(rgb2uv, INPUT.SampleLevel(sam_INPUT_LINEAR, HOOKED_map(pos), 0).rgb);
	OUTPUT[pos] = float4(mul(yuv2rgb, float3(value.x, UV)), 1.0);
}

#define INPUT_tex(pos) GET_SAMPLE(vec4(texture(INPUT, pos)))
static const float2 INPUT_size = float2(GetInputSize());
static const float2 INPUT_pt = float2(GetInputPt());

#define ravu_zoom_lut3_tex(pos) (vec4(texture(ravu_zoom_lut3, pos)))

#define HOOKED_tex(pos) INPUT_tex(pos)
#define HOOKED_size INPUT_size
#define HOOKED_pt INPUT_pt

void Pass1(uint2 blockStart, uint3 threadId) {
	ivec2 group_begin = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
	ivec2 group_end = group_begin + ivec2(gl_WorkGroupSize) - ivec2(1, 1);
	ivec2 rectl = ivec2(floor(HOOKED_size * HOOKED_map(group_begin) - 0.5001)) - 2;
	ivec2 rectr = ivec2(floor(HOOKED_size * HOOKED_map(group_end) - 0.4999)) + 3;
	ivec2 rect = rectr - rectl + 1;
	for (int id = int(gl_LocalInvocationIndex); id < rect.x * rect.y;
		 id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
		uint y = (uint)id / rect.x, x = (uint)id % rect.x;
		samples[x + y * 38] = HOOKED_tex(HOOKED_pt * (vec2(rectl + ivec2(x, y)) + vec2(0.5, 0.5))).x;
	}
	barrier();
#if CURRENT_PASS == LAST_PASS
	uint2 destPos = blockStart + threadId.xy;
	uint2 outputSize = GetOutputSize();
	if (destPos.x >= outputSize.x || destPos.y >= outputSize.y) {
		return;
	}
#endif
	vec2 pos = HOOKED_size * HOOKED_map(ivec2(gl_GlobalInvocationID));
	vec2 subpix = fract(pos - 0.5);
	pos -= subpix;
	subpix = LUTPOS(subpix, vec2(9.0, 9.0));
	vec2 subpix_inv = 1.0 - subpix;
	subpix /= vec2(5.0, 288.0);
	subpix_inv /= vec2(5.0, 288.0);
	ivec2 ipos = ivec2(floor(pos)) - rectl;
	int lpos = ipos.x + ipos.y * 38;
	float sample0 = samples[-78 + lpos];
	float sample1 = samples[-40 + lpos];
	float sample2 = samples[-2 + lpos];
	float sample3 = samples[36 + lpos];
	float sample4 = samples[74 + lpos];
	float sample5 = samples[112 + lpos];
	float sample6 = samples[-77 + lpos];
	float sample7 = samples[-39 + lpos];
	float sample8 = samples[-1 + lpos];
	float sample9 = samples[37 + lpos];
	float sample10 = samples[75 + lpos];
	float sample11 = samples[113 + lpos];
	float sample12 = samples[-76 + lpos];
	float sample13 = samples[-38 + lpos];
	float sample14 = samples[0 + lpos];
	float sample15 = samples[38 + lpos];
	float sample16 = samples[76 + lpos];
	float sample17 = samples[114 + lpos];
	float sample18 = samples[-75 + lpos];
	float sample19 = samples[-37 + lpos];
	float sample20 = samples[1 + lpos];
	float sample21 = samples[39 + lpos];
	float sample22 = samples[77 + lpos];
	float sample23 = samples[115 + lpos];
	float sample24 = samples[-74 + lpos];
	float sample25 = samples[-36 + lpos];
	float sample26 = samples[2 + lpos];
	float sample27 = samples[40 + lpos];
	float sample28 = samples[78 + lpos];
	float sample29 = samples[116 + lpos];
	float sample30 = samples[-73 + lpos];
	float sample31 = samples[-35 + lpos];
	float sample32 = samples[3 + lpos];
	float sample33 = samples[41 + lpos];
	float sample34 = samples[79 + lpos];
	float sample35 = samples[117 + lpos];
	vec3 abd = vec3(0.0, 0.0, 0.0);
	float gx, gy;
	gx = (sample13 - sample1) / 2.0;
	gy = (sample8 - sample6) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
	gx = (sample14 - sample2) / 2.0;
	gy = (-sample10 + 8.0 * sample9 - 8.0 * sample7 + sample6) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (sample15 - sample3) / 2.0;
	gy = (-sample11 + 8.0 * sample10 - 8.0 * sample8 + sample7) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (sample16 - sample4) / 2.0;
	gy = (sample11 - sample9) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
	gx = (-sample25 + 8.0 * sample19 - 8.0 * sample7 + sample1) / 12.0;
	gy = (sample14 - sample12) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (-sample26 + 8.0 * sample20 - 8.0 * sample8 + sample2) / 12.0;
	gy = (-sample16 + 8.0 * sample15 - 8.0 * sample13 + sample12) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
	gx = (-sample27 + 8.0 * sample21 - 8.0 * sample9 + sample3) / 12.0;
	gy = (-sample17 + 8.0 * sample16 - 8.0 * sample14 + sample13) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
	gx = (-sample28 + 8.0 * sample22 - 8.0 * sample10 + sample4) / 12.0;
	gy = (sample17 - sample15) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (-sample31 + 8.0 * sample25 - 8.0 * sample13 + sample7) / 12.0;
	gy = (sample20 - sample18) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (-sample32 + 8.0 * sample26 - 8.0 * sample14 + sample8) / 12.0;
	gy = (-sample22 + 8.0 * sample21 - 8.0 * sample19 + sample18) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
	gx = (-sample33 + 8.0 * sample27 - 8.0 * sample15 + sample9) / 12.0;
	gy = (-sample23 + 8.0 * sample22 - 8.0 * sample20 + sample19) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.07901060453704994;
	gx = (-sample34 + 8.0 * sample28 - 8.0 * sample16 + sample10) / 12.0;
	gy = (sample23 - sample21) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (sample31 - sample19) / 2.0;
	gy = (sample26 - sample24) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
	gx = (sample32 - sample20) / 2.0;
	gy = (-sample28 + 8.0 * sample27 - 8.0 * sample25 + sample24) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (sample33 - sample21) / 2.0;
	gy = (-sample29 + 8.0 * sample28 - 8.0 * sample26 + sample25) / 12.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06153352068439959;
	gx = (sample34 - sample22) / 2.0;
	gy = (sample29 - sample27) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04792235409415088;
	float a = abd.x, b = abd.y, d = abd.z;
	float T = a + d, D = a * d - b * b;
	float delta = sqrt(max(T * T / 4.0 - D, 0.0));
	float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
	float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
	float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
	float lambda = sqrtL1;
	float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
	float angle = floor(theta * 24.0 / 3.141592653589793);
	float strength = mix(mix(0.0, 1.0, lambda >= 0.004), mix(2.0, 3.0, lambda >= 0.05), lambda >= 0.016);
	float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
	float coord_y = ((angle * 4.0 + strength) * 3.0 + coherence) / 288.0;
	float res = 0.0;
	vec4 w;
	w = texture(ravu_zoom_lut3, vec2(0.0, coord_y) + subpix);
	res += sample0 * w[0];
	res += sample1 * w[1];
	res += sample2 * w[2];
	res += sample3 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.2, coord_y) + subpix);
	res += sample4 * w[0];
	res += sample5 * w[1];
	res += sample6 * w[2];
	res += sample7 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.4, coord_y) + subpix);
	res += sample8 * w[0];
	res += sample9 * w[1];
	res += sample10 * w[2];
	res += sample11 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.6, coord_y) + subpix);
	res += sample12 * w[0];
	res += sample13 * w[1];
	res += sample14 * w[2];
	res += sample15 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.8, coord_y) + subpix);
	res += sample16 * w[0];
	res += sample17 * w[1];
	w = texture(ravu_zoom_lut3, vec2(0.0, coord_y) + subpix_inv);
	res += sample35 * w[0];
	res += sample34 * w[1];
	res += sample33 * w[2];
	res += sample32 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.2, coord_y) + subpix_inv);
	res += sample31 * w[0];
	res += sample30 * w[1];
	res += sample29 * w[2];
	res += sample28 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.4, coord_y) + subpix_inv);
	res += sample27 * w[0];
	res += sample26 * w[1];
	res += sample25 * w[2];
	res += sample24 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.6, coord_y) + subpix_inv);
	res += sample23 * w[0];
	res += sample22 * w[1];
	res += sample21 * w[2];
	res += sample20 * w[3];
	w = texture(ravu_zoom_lut3, vec2(0.8, coord_y) + subpix_inv);
	res += sample19 * w[0];
	res += sample18 * w[1];
	res = clamp(res, 0.0, 1.0);
	imageStore(out_image, ivec2(gl_GlobalInvocationID), res);
}
