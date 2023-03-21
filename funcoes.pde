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
      popMatrix();
      //FACES PERPENDICULARES A z
      pushMatrix();
        rotateY(i * PI);
        float[] b = {dim.x, dim.y};
        quadri(new PVector(0, 0, Q.z), b, new PVector(HALF_PI, 0, 0));
      popMatrix();
      //FACES PERPENDICULARES A y
      pushMatrix();
        rotateX(i * PI);
        float[] c = {dim.x, dim.z};
        quadri(new PVector(0, Q.y, 0), c, new PVector(0, 0, 0));
      popMatrix();
    }
    
  popMatrix();
}

void caixaVOX(PVector P, PVector dim){
  caixa(new PVector(P.x * vox, P.y * vox, P.z * vox), new PVector(dim.x * vox, dim.y * vox, dim.z * vox));
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

// Função tipo point() onde faz já a conversão para vox (DEBUG)
void ponto(float x, float y, float z){
  point(x * vox, y * vox, z * vox);
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


/////////////////////////////////////////////////////////
///////////////////
// FUNÇÕES PARA MANIPULAÇÃO DA CÂMERA

  //define camera
void setCamera(){
  camera(
  1000, py, 1000,
  0,   yLookAt,    0,
  upX, 1,    upZ);
}

  //gira a camera perante o eixo da direção do olhar
void tiltCamera(){
  if(keys[LEFT] || keys[RIGHT]){
    if(keys[LEFT]){
      upZ += incPY;
      upX -= incPY;
    }
    else{
      upZ -= incPY;
      upX += incPY;
    }

    if(upZ > limitesUp[1]) upZ = limitesUp[1];
    else if(upZ < limitesUp[0]) upZ = limitesUp[0];

    if(upX > limitesUp[1]) upX = limitesUp[1];
    else if(upX < limitesUp[0]) upX = limitesUp[0];
  }
}

  //muda a posição y de onde olha (direção)
void yLookCamera(){
  if(keys[UP] || keys[DOWN]){
    if(keys[UP]) yLookAt -= incYLook;
    else yLookAt += incYLook;
  }
}