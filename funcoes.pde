void quadri(PVector P, float[] dim, PVector rot){
  float[] hDim = {dim[0] * 0.5, dim[1] * 0.5};
  pushMatrix();
    t(P);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    beginShape(QUADS);
      vertex(hDim[0], 0, hDim[1]);
      vertex(hDim[0], 0, -hDim[1]);
      vertex(-hDim[0], 0, -hDim[1]);
      vertex(-hDim[0], 0, hDim[1]);
    endShape();
  popMatrix();
}

void quadriVOX(PVector P, float[] dim, PVector rot){
  quadri(new PVector(P.x * vox, P.y * vox, P.z * vox), new float[]{dim[0] * vox, dim[1] * vox}, new PVector(rot.x, rot.y, rot.z));
}

void caixa(PVector P, PVector dim){
  PVector Q = new PVector(dim.x * 0.5, dim.y * 0.5, dim.z * 0.5);
  
  pushMatrix();
    t(P);
    for(int i = 0; i < 2; i++){
      //FACES PERPENDICULARES A x
      pushMatrix();
        rotateY(i * PI);
        float[] a = {dim.y, dim.z};
        quadri(new PVector(Q.x, 0, 0), a, new PVector(0, 0, HALF_PI));
        /*
        beginShape(QUADS);
          vertex(Q.x, Q.y, Q.z);
          vertex(Q.x, -Q.y, Q.z);
          vertex(Q.x, -Q.y, -Q.z);
          vertex(Q.x, Q.y, -Q.z);
        endShape();
        */
      popMatrix();
      //ACES PERPENDICULARES A z
      pushMatrix();
        rotateY(i * PI);
        float[] b = {dim.x, dim.y};
        quadri(new PVector(0, 0, Q.z), b, new PVector(HALF_PI, 0, 0));
        /*
        beginShape(QUADS);
          vertex(Q.x, Q.y, Q.z);
          vertex(Q.x, -Q.y, Q.z);
          vertex(-Q.x, -Q.y, Q.z);
          vertex(-Q.x, Q.y, Q.z);
        endShape();
        */
      popMatrix();
      //ACES PERPENDICULARES A y
      pushMatrix();
        rotateX(i * PI);
        float[] c = {dim.x, dim.z};
        quadri(new PVector(0, Q.y, 0), c, new PVector(0, 0, 0));
        /*
        beginShape(QUADS);
          vertex(Q.x, Q.y, Q.z);
          vertex(-Q.x, Q.y, Q.z);
          vertex(-Q.x, Q.y, -Q.z);
          vertex(Q.x, Q.y, -Q.z);
        endShape();
        */
      popMatrix();
    }
    
  popMatrix();
}

// Função tipo translate() para receber um PVector e ir logo direto
void t(PVector P){
  translate(P.x, P.y, P.z);
}

// Função tipo translate() onde faz já a conversão para vox (a unidade básica > ver 'vars.pde':3)
void translacao(float x, float y, float z){
  translate(x * vox, y * vox, z * vox);
}

// Função tipo vertex() onde faz já a conversão para vox
void vertice(float x, float y, float z){
  vertex(x * vox, y * vox, z * vox);
}


////

// Função que coloca visível os eixos
void eixos(){
  pushStyle();
    stroke(255, 0, 0);
    line(0, 0, 0, 1000, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 1000, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 1000);
  popStyle();
}