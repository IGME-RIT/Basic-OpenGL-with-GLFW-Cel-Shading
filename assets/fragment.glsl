/*
Title: Cel Shading
File Name: fragment.glsl
Copyright ? 2016
Author: David Erbelding
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#version 400 core

in vec2 uv;
in vec3 normal;

uniform sampler2D tex;

void main(void)
{
	vec4 ambientLight = vec4(.1, .1, .2, 1);
	vec4 lightColor = vec4(.9, .7, .1, 1);
	vec3 lightDir = vec3(-1, -1, -2);

	// calculate diffuse lighting and clamp between 0 and 1
	float ndotl = clamp(-dot(normalize(lightDir), normalize(normal)), 0, 1); 

	// This is all that's required for basic cel shading:
	// We choose a number of shades
	float shades = 3;
	
	// we have our lighting value scaled by the number of shades, this gives a range of 0 to # shades.
	// ceil then rounds each value up, so any value in between will all end up being the same.
	// lastly we divide bringing the range back between 0 and 1.
	float lightStrength = ceil(ndotl * shades) / shades;

	// for more customizable cel shading, instead of using this math to calculate a value,
	// you can read from a 1d texture, using light strength as the coordinate.
	// a 1d texture gives full control over the color and size of each interval.
	// This can be used to create a weather-map style effect.

	// add diffuse lighting to ambient lighting and clamp a second time
	vec4 finalLight = clamp(lightColor * lightStrength + ambientLight, 0, 1);

	// finally, sample from the texuture and multiply in the light.
	gl_FragColor = texture(tex, uv) * finalLight;
}