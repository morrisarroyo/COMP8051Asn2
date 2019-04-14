#import <OpenGLES/ES2/glext.h>

typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColour,
    VertexAttribTexCoord,
    VertexAttribNormal
} VertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Colour[4];
    GLfloat TexCoord[2];
    GLfloat Normal[3];
} Vertex;


