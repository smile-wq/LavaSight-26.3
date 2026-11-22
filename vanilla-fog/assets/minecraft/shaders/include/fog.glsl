#ifndef MINECRAFT_FOG_GLSL
#define MINECRAFT_FOG_GLSL

// Uniform layout used by the Java 26.3 client.
layout(std140) uniform Fog {
    vec4 FogColor;
    float FogEnvironmentalStart;
    float FogEnvironmentalEnd;
    float FogRenderDistanceStart;
    float FogRenderDistanceEnd;
    float FogSkyEnd;
    float FogCloudsEnd;
};

bool lavasight_is_lava_fog() {
    bool immersed = FogEnvironmentalStart == 0.25 && FogEnvironmentalEnd == 1.0;
    bool fireResistant = FogEnvironmentalStart == 0.0 && FogEnvironmentalEnd == 5.0;
    bool spectating = FogEnvironmentalStart == -8.0 && FogEnvironmentalEnd == 0.5 * FogRenderDistanceEnd;

    // Tweakeroo changes terrain fog after vanilla copies the original lava
    // cutoff to sky and clouds. The terrain cutoff can grow with enchantments.
    bool originalCutoff = FogSkyEnd == FogCloudsEnd && FogEnvironmentalEnd >= FogSkyEnd;
    bool tweakedLava = originalCutoff && (
        (FogEnvironmentalStart == 0.0 && (FogSkyEnd == 1.0 || FogSkyEnd == 5.0)) ||
        (FogEnvironmentalStart == -8.0 && FogSkyEnd == 0.5 * FogRenderDistanceEnd)
    );
    // Powder snow shares the spectator range.
    bool lavaHue = FogColor.b == 0.0 && FogColor.g > 0.0 && FogColor.r > 4.0 * FogColor.g;
    return lavaHue && (immersed || fireResistant || spectating || tweakedLava);
}

float linear_fog_value(float distanceToCamera, float start, float end) {
    // Some vanilla passes use a zero-width fog range.
    if (end <= start) {
        return distanceToCamera > start ? 1.0 : 0.0;
    }
    return clamp((distanceToCamera - start) / (end - start), 0.0, 1.0);
}

float total_fog_value(float spherical, float cylindrical, float envStart, float envEnd, float farStart, float farEnd) {
    float farFog = linear_fog_value(cylindrical, farStart, farEnd);
    if (lavasight_is_lava_fog()) {
        return farFog;
    }
    return max(farFog, linear_fog_value(spherical, envStart, envEnd));
}

vec4 apply_fog(vec4 surface, float spherical, float cylindrical, float envStart, float envEnd,
               float farStart, float farEnd, vec4 fog) {
    float amount = total_fog_value(spherical, cylindrical, envStart, envEnd, farStart, farEnd);
    return vec4(mix(surface.rgb, fog.rgb, fog.a * amount), surface.a);
}

float fog_spherical_distance(vec3 offset) {
    return length(offset);
}

float fog_cylindrical_distance(vec3 offset) {
    return max(abs(offset.y), length(offset.xz));
}

#endif
