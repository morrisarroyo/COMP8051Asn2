varying lowp vec4 frag_Colour;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColour;
uniform lowp float u_DayNightFactor;

struct Light {
    lowp vec3 Colour;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};

struct Flashlight {
    lowp float Radius;
    lowp float Active;
    lowp float Intensity;
    lowp vec2 Viewport;
};

struct Fog {
    lowp vec4 Colour;
    lowp float Start;
    lowp float End;
    lowp float Active;
};

uniform Light u_Light;
uniform Flashlight u_Flashlight;
uniform Fog u_Fog;

void main(void) {
    
    //Ambient
    lowp vec3 AmbientColour = u_Light.Colour * u_Light.AmbientIntensity * u_DayNightFactor;
    
    //Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp float DiffuseFactor = max(-dot(Normal, u_Light.Direction), 0.0);
    lowp vec3 DiffuseColour = u_Light.Colour * u_Light.DiffuseIntensity * DiffuseFactor * u_DayNightFactor;
    
    //Specular
    lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 Reflection = reflect(u_Light.Direction, Normal);
    lowp float SpecularFactor = pow(max(0.0, -dot(Reflection, Eye)), u_Shininess);
    lowp vec3 SpecularColour = u_Light.Colour * u_MatSpecularIntensity * SpecularFactor;
    //u_Flashlight.Radius = 1;
    
    if (u_Flashlight.Active == 1.0) {
        lowp float minSize = min (u_Flashlight.Viewport.x, u_Flashlight.Viewport.y);
        lowp vec2 normalizedViewport =  normalize(u_Flashlight.Viewport);
        lowp vec2 pos = gl_FragCoord.xy;
        pos.x = (pos.x / (u_Flashlight.Viewport.x ))  - (u_Flashlight.Viewport.x/ minSize);
        pos.y = (pos.y / (u_Flashlight.Viewport.y)) - (u_Flashlight.Viewport.x/ minSize);
        if (length(pos) <= u_Flashlight.Radius) {
            if (u_DayNightFactor < 1.0) {
                DiffuseColour =  DiffuseColour / u_DayNightFactor;

            } else {
                DiffuseColour =  DiffuseColour * u_Flashlight.Intensity;
            }
        }
    }
    if (u_Fog.Active == 1.0) {
        lowp float dist = (gl_FragCoord.z / gl_FragCoord.w);
        lowp vec4 FogColour = u_Fog.Colour;
        lowp float FogFactor = (u_Fog.End - dist) / (u_Fog.End - u_Fog.Start);
        FogFactor = clamp(FogFactor, 0.0, 1.0);
        gl_FragColor = mix(FogColour, u_MatColour * texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColour + DiffuseColour + SpecularColour), 1.0), FogFactor);
    } else {
        gl_FragColor = u_MatColour * texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColour + DiffuseColour + SpecularColour), 1.0);
    }
}
