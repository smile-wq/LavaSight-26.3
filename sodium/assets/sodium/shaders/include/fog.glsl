// Terrain fog interface used by Sodium 0.9.2 on Minecraft 26.3.
const int FOG_SHAPE_SPHERICAL = 0;
const int FOG_SHAPE_CYLINDRICAL = 1;

float linear_fog_value(float distanceToCamera, float start, float end) {
    if (distanceToCamera <= start) {
        return 0.0;
    }
    if (distanceToCamera >= end) {
        return 1.0;
    }
    return (distanceToCamera - start) / (end - start);
}

float total_fog_value(float spherical, float cylindrical, float envStart, float envEnd, float farStart, float farEnd) {
    return max(linear_fog_value(spherical, envStart, envEnd),
               linear_fog_value(cylindrical, farStart, farEnd));
}

bool lavasight_is_lava(vec3 color, vec2 environment, float farEnd) {
    // Vanilla lava is #991900. Brightness changes preserve its channel ratio.
    bool lavaColor = color.r > 0.0 && color.b == 0.0
                  && abs(color.g - color.r * (25.0 / 153.0)) < 0.001 * color.r;
    bool immersed = environment.x == 0.25 && environment.y == 1.0;
    // With normal enchantment levels, Tweakeroo extends lava fog up to 25.344 blocks.
    bool shortRange = environment.y >= 1.0 && environment.y < 26.0;
    bool zeroStart = environment.x == 0.0 && shortRange;
    float spectatorEnd = 0.5 * farEnd;
    bool spectating = environment.x == -8.0 && (environment.y == spectatorEnd ||
                      (shortRange && environment.y > spectatorEnd));
    return lavaColor && (immersed || zeroStart || spectating);
}

vec4 _linearFog(vec4 surface, vec2 distanceToCamera, vec4 fogColor, vec2 environment, vec2 renderFog, float fadeFactor) {
#ifdef USE_FOG
    // The accumulation pass premultiplies fogColor by the surface alpha.
    float amount = lavasight_is_lava(u_FogColor.rgb, environment, renderFog.y)
        ? linear_fog_value(distanceToCamera.x, renderFog.x, renderFog.y)
        : total_fog_value(distanceToCamera.y, distanceToCamera.x, environment.x, environment.y, renderFog.x, renderFog.y);
    amount = max(1.0 - fadeFactor, amount);
    return vec4(mix(surface.rgb, fogColor.rgb, amount * fogColor.a), surface.a);
#else
    return surface;
#endif
}

vec2 getFragDistance(vec3 position) {
    return vec2(max(length(position.xz), abs(position.y)), length(position));
}
