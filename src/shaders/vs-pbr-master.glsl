#define POSITION_LOCATION 0
#define NORMAL_LOCATION 1
#define TEXCOORD_0_LOCATION 2
#define JOINTS_0_LOCATION 3
#define JOINTS_1_LOCATION 5
#define WEIGHTS_0_LOCATION 4
#define WEIGHTS_1_LOCATION 6

precision highp float;
precision highp int;

uniform mat4 u_MVP;
uniform mat4 u_MVNormal;

#ifdef HAS_SKIN
uniform JointMatrix
{
    mat4 matrix[32];
} u_jointMatrix;
#endif

layout(location = POSITION_LOCATION) in vec3 position;
layout(location = NORMAL_LOCATION) in vec3 normal;
layout(location = TEXCOORD_0_LOCATION) in vec2 uv;

#ifdef HAS_SKIN
layout(location = JOINTS_0_LOCATION) in vec4 joint0;
layout(location = WEIGHTS_0_LOCATION) in vec4 weight0;
#ifdef SKIN_VEC8
layout(location = JOINTS_1_LOCATION) in vec4 joint1;
layout(location = WEIGHTS_1_LOCATION) in vec4 weight1;
#endif
#endif
// TODO: tangents

out vec3 v_normal;
out vec2 v_uv;

void main()
{

#ifdef HAS_SKIN
    mat4 skinMatrix = 
        weight0.x * u_jointMatrix.matrix[int(joint0.x)] +
        weight0.y * u_jointMatrix.matrix[int(joint0.y)] +
        weight0.z * u_jointMatrix.matrix[int(joint0.z)] +
        weight0.w * u_jointMatrix.matrix[int(joint0.w)];
#ifdef SKIN_VEC8
    skinMatrix +=
        weight1.x * u_jointMatrix.matrix[int(joint1.x)] +
        weight1.y * u_jointMatrix.matrix[int(joint1.y)] +
        weight1.z * u_jointMatrix.matrix[int(joint1.z)] +
        weight1.w * u_jointMatrix.matrix[int(joint1.w)];
#endif
#endif

#ifdef HAS_SKIN
    v_normal = normalize(( u_MVNormal * transpose(inverse(skinMatrix)) * vec4(normal, 0)).xyz);
#else
    v_normal = normalize((u_MVNormal * vec4(normal, 0)).xyz);
#endif
    
    v_uv = uv;
    gl_Position = u_MVP * vec4(position, 1.0) ;
}