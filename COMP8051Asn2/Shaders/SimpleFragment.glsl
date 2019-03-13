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
    lowp vec3 Position;
    lowp vec3 Direction;
    lowp float Cutoff;
};

uniform Light u_Light;
uniform Flashlight u_FlashLight;
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
    lowp vec3 SpecularColour = u_Light.Colour * u_MatSpecularIntensity * SpecularFactor * u_DayNightFactor;
    
    highp float theta = dot(-( u_FlashLight.Position - gl_FragCoord.xyz), normalize(u_FlashLight.Direction));
    if (theta > u_FlashLight.Cutoff) {
        //Diffuse
        lowp vec3 Normal = normalize(frag_Normal);
        lowp float DiffuseFactor = max(-dot(Normal, u_FlashLight.Direction), 0.0);
        if (u_DayNightFactor < 1.0) {
            DiffuseColour =  DiffuseColour / u_DayNightFactor * 1.5;
        }

        
    }
    gl_FragColor = u_MatColour * texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColour + DiffuseColour + SpecularColour), 1.0);
}
