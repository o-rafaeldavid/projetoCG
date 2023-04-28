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

void quadriTextura(PVector P, float[] dim, PVector rot, PImage textura, int[] vezes){
  if(textura == null || vezes == null) quadri(P, dim, rot);
  else{
    float[] hDim = {dim[0] * 0.5, dim[1] * 0.5};
    pushMatrix();
      t(P);
      rotateX(rot.x);
      rotateY(rot.y);
      rotateZ(rot.z);
      beginShape(QUADS);
        texture(textura);
        vertex(hDim[0], 0, hDim[1], 0, vezes[1]);
        vertex(hDim[0], 0, -hDim[1], vezes[0], vezes[1]);
        vertex(-hDim[0], 0, -hDim[1], vezes[0], 0);
        vertex(-hDim[0], 0, hDim[1], 0, 0);
      endShape();
    popMatrix();
  }
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

void caixaTextura(PVector P, PVector dim, PImage[] textura, int[][] vezes){
  PVector Q = new PVector(dim.x * 0.5, dim.y * 0.5, dim.z * 0.5);
  
  pushMatrix();
    t(P);
    for(int i = 0; i < 2; i++){
      //FACES PERPENDICULARES A x
      pushMatrix();
        rotateY(i * PI);
        float[] a = {dim.y, dim.z};
        quadriTextura(new PVector(Q.x, 0, 0), a, new PVector(0, 0, HALF_PI), textura[i], vezes[i]);
      popMatrix();
      //FACES PERPENDICULARES A z
      pushMatrix();
        rotateY(i * PI);
        float[] b = {dim.x, dim.y};
        quadriTextura(new PVector(0, 0, Q.z), b, new PVector(HALF_PI, 0, 0), textura[i + 2], vezes[i + 2]);
      popMatrix();
      //FACES PERPENDICULARES A y
      pushMatrix();
        rotateX(i * PI);
        float[] c = {dim.x, dim.z};
        quadriTextura(new PVector(0, Q.y, 0), c, new PVector(0, 0, 0), textura[i + 4], vezes[i + 4]);
      popMatrix();
    }
    
  popMatrix();
}

void caixaVOX(PVector P, PVector dim){
  caixa(new PVector(P.x * vox, P.y * vox, P.z * vox), new PVector(dim.x * vox, dim.y * vox, dim.z * vox));
}

void caixaTexturaVOX(PVector P, PVector dim, PImage[] textura, int[][] vezes){
  caixaTextura(
      new PVector(P.x * vox, P.y * vox, P.z * vox),
      new PVector(dim.x * vox, dim.y * vox, dim.z * vox),
      textura,
      vezes
  );
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

  //texto
  push();
    ambient(255);
    emissive(255);
    translate(900, 0, 900);
    rotateY(QUARTER_PI);
    fill(255);
    textSize(20);
    //colocar o texto relativo ao sistemaP[0]
    text("Características dos prédios tipo 0:\nAmbiente  (8, 9, 0) > R:" + red(sistemaP[0].ambient) + " G:" + green(sistemaP[0].ambient) + " B:" + blue(sistemaP[0].ambient)
    + "\nEspecular (I, O, P) > R:" + red(sistemaP[0].specular) + " G:" + green(sistemaP[0].specular) + " B:" + blue(sistemaP[0].specular)
    + "\nDifusa        (K, L, Ç) > R:" + red(sistemaP[0].diffuse) + " G:" + green(sistemaP[0].diffuse) + " B:" + blue(sistemaP[0].diffuse)
    + "\ncom o SHIFT diminui", -850, py + 300, 0);
    //colocar o texto relativo às teclas
    text("Restantes controlos:\nCTRL + Mouse1/2 > roda a cena\nScroll > zoom-in e zoom-out\nSetas > rodam a câmara\nB > liga e desliga o candeeiro",
    500, py + 300, 0);
  pop();
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
    color(5, 2, 15),
    color(255, 3, 255),
    color(#0a1024),
    1
  );

  sistemaJ[0] = new SistemaCor(
    color(0, 255, 255),
    color(5, 1, 15),
    color(255, 10, 255),
    color(0, 255, 255),
    10
  );

  /////////////////

  sistemaP[1] = new SistemaCor(
    color(#150a24),
    color(2, 1, 15),
    color(100, 1, 255),
    color(#150a24),
    1
  );

  sistemaJ[1] = new SistemaCor(
    color(255, 0, 255),
    color(2, 1, 15),
    color(100, 8, 255),
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
  color spc = sistemaP[0].specular;
  color dif = sistemaP[0].diffuse;
  
  //  AMBIENT
  if(keys['8'] && red(amb) >= 0 && red(amb) <= 255){
    if(keys[SHIFT] && red(amb) > 0) sistemaP[0].ambient = color(red(amb) - 1, green(amb), blue(amb));
    else if(red(amb) < 255) sistemaP[0].ambient = color(red(amb) + 1, green(amb), blue(amb));
  }
  if(keys['9'] && green(amb) >= 0 && green(amb) <= 255){
    if(keys[SHIFT] && green(amb) > 0) sistemaP[0].ambient = color(red(amb), green(amb) - 1, blue(amb));
    else if(green(amb) < 255) sistemaP[0].ambient = color(red(amb), green(amb) + 1, blue(amb));
  }
  if(keys['0'] && blue(amb) >= 0 && blue(amb) <= 255){
    if(keys[SHIFT] && blue(amb) > 0) sistemaP[0].ambient = color(red(amb), green(amb), blue(amb)- 1);
    else if(blue(amb) < 255) sistemaP[0].ambient = color(red(amb), green(amb), blue(amb) + 1);
  }


  //  SPECULAR
  if(keys['I'] && red(spc) >= 0 && red(spc) <= 255){
    if(keys[SHIFT] && red(spc) > 0) sistemaP[0].specular = color(red(spc) - 1, green(spc), blue(spc));
    else if(red(spc) < 255) sistemaP[0].specular = color(red(spc) + 1, green(spc), blue(spc));
  }
  if(keys['O'] && green(spc) >= 0 && green(spc) <= 255){
    if(keys[SHIFT] && green(spc) > 0) sistemaP[0].specular = color(red(spc), green(spc) - 1, blue(spc));
    else if(green(spc) < 255) sistemaP[0].specular = color(red(spc), green(spc) + 1, blue(spc));
  }
  if(keys['P'] && blue(spc) >= 0 && blue(spc) <= 255){
    if(keys[SHIFT] && blue(spc) > 0) sistemaP[0].specular = color(red(spc), green(spc), blue(spc) - 1);
    else if(blue(spc) < 255) sistemaP[0].specular = color(red(spc), green(spc), blue(spc) + 1);
  }

  //  DIFFUSE
  if(keys['K'] && red(dif) >= 0 && red(dif) <= 255){
    if(keys[SHIFT] && red(dif) > 0) sistemaP[0].diffuse = color(red(dif) - 1, green(dif), blue(dif));
    else if(red(dif) < 255) sistemaP[0].diffuse = color(red(dif) + 1, green(dif), blue(dif));
  }
  if(keys['L'] && green(dif) >= 0 && green(dif) <= 255){
    if(keys[SHIFT] && green(dif) > 0) sistemaP[0].diffuse = color(red(dif), green(dif) - 1, blue(dif));
    else if(green(dif) < 255) sistemaP[0].diffuse = color(red(dif), green(dif) + 1, blue(dif));
  }
  if(keys[59] && blue(dif) >= 0 && blue(dif) <= 255){
    if(keys[SHIFT] && blue(dif) > 0) sistemaP[0].diffuse = color(red(dif), green(dif), blue(dif) - 1);
    else if(blue(dif) < 255) sistemaP[0].diffuse = color(red(dif), green(dif), blue(dif) + 1);
  }
}

//////////////////////////////////////

// criar um candeeiro

void candeeiroVOX(PVector P, float altura, float a_lampada){
  push();
    tVox(P);

    if(candeeiros){
      /*
      pointLight(10, 10, 0,
          0, -1 * (altura + 2 * a_lampada) * vox, 0
      );
      */

      spotLight(10, 10, 0,
      0, -1 * (altura + 2 * a_lampada) * vox, 0,
      0, 1, 0,
      PI,
      0.25);

      fill(255, 190, 40);
      ambient(255, 190, 40);
      emissive(6, 14, 2);
      specular(2, 8, 0);
      brightness(100);
    }
    else{
      fill(100);
      ambient(70, 70, 70);
      emissive(0);
      specular(0);
    }

    caixaVOX(
      new PVector(0, -1 * (altura + a_lampada * .5f), 0),
      new PVector(a_lampada, a_lampada, a_lampada)
    );

    fill(20);
    ambient(50, 50, 50);
    emissive(0);
    specular(0);
    caixaVOX(
      new PVector(0, -altura * .5f, 0),
      new PVector(.5f, altura, .5f)
    );
  pop();
}