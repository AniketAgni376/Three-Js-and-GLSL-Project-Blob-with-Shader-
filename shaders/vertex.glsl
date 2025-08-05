#include simplexNoise4d.glsl
attribute vec3 tangent;

uniform float uTime;
uniform float uPositionFrequency;
uniform float uPositionStrength;
uniform float uTimeFrequency;

uniform float uSmallWavePositionFrequency;
uniform float uSmallWavePositionStrength;
uniform float uSmallWaveTimeFrequency;

float getBlob(vec3 position){

//The function applies a two-layer noise system:
    // ** First layer: Distorts the input position (like warping space).
    // ** Second layer: Adds fine noise details on the warped space — like small waves on top of big waves.

    vec3 wrappedPosition = position;
    wrappedPosition += simplexNoise4d(vec4(position * uPositionFrequency, uTime * uTimeFrequency))*uPositionStrength;
    return simplexNoise4d(vec4(wrappedPosition*uSmallWavePositionFrequency,uTime*uSmallWaveTimeFrequency))*uSmallWavePositionStrength;

}
void main(){
    vec3 bitangent = cross(tangent.xyz, normal);
    float shift = .07;
    vec3 A = csm_Position + shift * tangent.xyz;
    vec3 B = csm_Position - shift * bitangent;


    float blob = getBlob(csm_Position);
    csm_Position += blob*normal;

    A += getBlob(A)*normal;
    B += getBlob(B)*normal;

    vec3 finalA =  normalize(A - csm_Position);
    vec3 finalB =  normalize(B - csm_Position);

    csm_Normal = -cross(finalA, finalB);

    
    
}