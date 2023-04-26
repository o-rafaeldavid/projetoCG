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

void tVox(PVector P){
  translate(P.x * vox, P.y * vox, P.z * vox);
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

// Função tipo line() onde faz já a conversão para vox (DEBUG)
void linha(float x, float y, float z, float a, float b, float c){
  line(x * vox, y * vox, z * vox, a * vox, b * vox, c * vox);
}

// Funcao tipo dist para pvector
float distancia(PVector P, PVector Q){
  float f = dist(P.x, P.y, P.z, Q.x, Q.y, Q.z);
  return f;
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

void vazio(){}


/////////////////////////////////////////////////////////
///////////////////
//funcao usada no setup para definir os sistemas de cores/materias
void definirSistemas(){
  sistemaP[0] = new SistemaCor(
    color(#0a1024),
    color(15, 0, 5),
    color(255, 0, 255),
    color(#0a1024),
    1
  );

  sistemaJ[0] = new SistemaCor(
    color(0, 255, 255),
    color(15, 0, 5),
    color(255, 0, 255),
    color(0, 255, 255),
    10
  );

  /////////////////

  sistemaP[1] = new SistemaCor(
    color(#150a24),
    color(2, 0, 15),
    color(100, 0, 255),
    color(#150a24),
    1
  );

  sistemaJ[1] = new SistemaCor(
    color(255, 0, 255),
    color(2, 0, 15),
    color(100, 0, 255),
    color(255, 0, 255),
    10
  );

  ////////////////////////////////////////////////////////////////////

  sistemaC[0] = new SistemaCor(
    color(#191a1f),
    color(8, 0, 8),
    color(190, 0, 190),
    color(#191a1f),
    1
  );

  sistemaJC[0] = new SistemaCor(
    color(#f07f1d),
    color(25, 10, 0),
    color(100, 250, 10),
    color(#f07f1d),
    10
  );

  /////////////////

  sistemaC[1] = new SistemaCor(
    color(#24212b),
    color(8, 0, 10),
    color(180, 0, 200),
    color(#24212b),
    1
  );

  sistemaJC[1] = new SistemaCor(
    color(#36f01d),
    color(5, 20, 0),
    color(40, 250, 20),
    color(#36f01d),
    10
  );
}


/*
  manipular o sistemaP[0] com o teclado

  AMBIENT  (R, G, B) => (8, 9, 0)
  SPECULAR (R, G, B) => (I, O, P)
  DIFFUSE  (R, G, B) => (K, L, Ç)
*/

void manipularSP0(){
  color amb = sistemaP[0].ambient;

  if(keys['7'] && red(amb) >= 0 && red(amb) <= 255){
    if(keys[SHIFT] && red(amb) > 0) sistemaP[0].ambient = color(red(amb) - 1, blue(amb), green(amb));
    else if(red(amb) < 255) sistemaP[0].ambient = color(red(amb) + 1, blue(amb), green(amb));
  }
}