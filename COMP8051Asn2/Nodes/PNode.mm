//
//  PNode.m
//  Tanks Go
//
//  Created by Jason Sekhon on 2019-02-22.
//  Copyright © 2019 Jason Sekhon. All rights reserved.
//

#import "PNode.h"

@implementation PNode {
    btCollisionShape *_shape;
}

- (instancetype)initWithName:(char *)name
                        mass:(float)mass
                      convex:(BOOL)convex
                         tag:(int)tag
                      shader:(BaseEffect *)shader
                    vertices:(Vertex *)vertices
                 vertexCount:(unsigned int)vertexCount
                 textureName:(NSString *)textureName
              specularColour:(GLKVector4)specularColour
               diffuseColour:(GLKVector4)diffuseColour
                   shininess:(float)shininess {
    
    if (self = [super initWithName:name shader:shader vertices:vertices vertexCount:vertexCount textureName:textureName specularColor:specularColour diffuseColor:diffuseColour shininess:shininess tag:tag]) {
        
        self.tag = tag;
        
        [self createShapeWithVertices:vertices count:vertexCount isConvex:convex];
        
        [self createBodyWithMass:mass];
    }
    return self;
}

- (void)createShapeWithVertices:(Vertex *)vertices count:(unsigned int)vertexCount isConvex:(BOOL)convex {
    if (convex) {
        _shape = new btConvexHullShape();
        int num = 1;
        if (vertexCount > 100)
            num = 10;
        for (int i = 0; i < vertexCount; i += num){
            Vertex v = vertices[i];
            NSLog(@"%d", i);
            btVector3 btv = btVector3(v.Position[0], v.Position[1], v.Position[2]);
            ((btConvexHullShape*)_shape)->addPoint(btv);
        }
    } else {
        btTriangleMesh* mesh = new btTriangleMesh();
        for (int i = 0; i < vertexCount; i+= 3) {
            Vertex v1 = vertices[i];
            Vertex v2 = vertices[i+1];
            Vertex v3 = vertices[i+2];
            NSLog(@"test");
            btVector3 bv1 = btVector3(v1.Position[0], v1.Position[1], v1.Position[2]);
            btVector3 bv2 = btVector3(v2.Position[0], v2.Position[1], v2.Position[2]);
            btVector3 bv3 = btVector3(v3.Position[0], v3.Position[1], v3.Position[2]);
            
            mesh->addTriangle(bv1, bv2, bv3);
        }
        _shape = new btBvhTriangleMeshShape(mesh, true);
    }
}

- (void)createBodyWithMass:(float)mass {
    btQuaternion rotation;
    rotation.setEulerZYX(self.rotationZ, self.rotationY, self.rotationX);
    
    btVector3 position = btVector3(self.position.x, self.position.y, self.position.z);
    
    btDefaultMotionState *motionState = new btDefaultMotionState(btTransform(rotation, position));
    
    btScalar bodyMass = mass;
    btVector3 bodyInertia;
    //if (mass != 0)
        _shape->calculateLocalInertia(bodyMass, bodyInertia);
    //else
      //  bodyInertia = btVector3(0, 0, 0);
    
    btRigidBody::btRigidBodyConstructionInfo bodyCI = btRigidBody::btRigidBodyConstructionInfo(bodyMass, motionState, _shape, bodyInertia);
    
    bodyCI.m_restitution = 0.0f;
    bodyCI.m_friction = 0.2f;
    
    _body = new btRigidBody(bodyCI);
    
    _body->setUserPointer((__bridge void*)self);
    
    _body->setLinearFactor(btVector3(1, 1, 1));
}

- (void) dealloc {
    if (_body) {
        delete _body->getMotionState();
        delete _body;
    }
    delete _shape;
}

- (void)setPosition:(GLKVector3)position {
    [super setPosition:position];
    
    if (_body) {
        btTransform trans = _body->getWorldTransform();
        trans.setOrigin(btVector3(position.x, position.y, position.z));
        _body->setWorldTransform(trans);
    }
}

-(GLKVector3)position {
    if (_body) {
        btTransform trans = _body->getWorldTransform();
        return GLKVector3Make(trans.getOrigin().x(), trans.getOrigin().y(), trans.getOrigin().z());
    } else {
        return [super position];
    }
}

- (void)setRotationX:(float)rotationX {
    [super setRotationX:rotationX];
    
    if (_body) {
        
        btTransform trans = _body->getWorldTransform();
        btQuaternion rot = trans.getRotation();
        
        float angleDiff = rotationX - self.rotationX;
        btQuaternion diffRot = btQuaternion(btVector3(1,0,0), angleDiff);
        rot = diffRot * rot;
        
        trans.setRotation(rot);
        _body->setWorldTransform(trans);
    }
}

-(float)rotationX {
    if (_body) {
        btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
        float z,y,x;
        rotMatrix.getEulerZYX(z,y,x);
        return x;
    }
    
    return [super rotationX];
}

-(void)setRotationY:(float)rotationY
{
    [super setRotationY:rotationY];
    
    if (_body)
    {
        btTransform trans = _body->getWorldTransform();
        btQuaternion rot = trans.getRotation();
        
        float angleDiff = rotationY - self.rotationY;
        btQuaternion diffRot = btQuaternion(btVector3(0,1,0), angleDiff);
        rot = diffRot * rot;
        
        trans.setRotation(rot);
        _body->setWorldTransform(trans);
    }
}

-(float)rotationY
{
    if (_body)
    {
        btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
        float z,y,x;
        rotMatrix.getEulerZYX(z,y,x);
        return y;
    }
    
    return [super rotationY];
}

-(void)setRotationZ:(float)rotationZ
{
    [super setRotationZ:rotationZ];
    
    if (_body)
    {
        btTransform trans = _body->getWorldTransform();
        btQuaternion rot = trans.getRotation();
        
        float angleDiff = rotationZ - self.rotationZ;
        btQuaternion diffRot = btQuaternion(btVector3(0,0,1), angleDiff);
        rot = diffRot * rot;
        
        trans.setRotation(rot);
        _body->setWorldTransform(trans);
    }
}

-(float)rotationZ
{
    if (_body)
    {
        btMatrix3x3 rotMatrix = btMatrix3x3(_body->getWorldTransform().getRotation());
        float z,y,x;
        rotMatrix.getEulerZYX(z,y,x);
        return z;
    }
    
    return [super rotationZ];
}

@end





