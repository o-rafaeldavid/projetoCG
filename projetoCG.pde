void settings(){
  size(1280, 720, P3D);
}

void setup(){
  surface.setTitle("Projeto de CG");
  definirSistemas();
  setCamera();
  
  mao[0] = loadImage("cursors/mao_aberta.png");
  mao[1] = loadImage("cursors/mao_fechada.png");

  estrada = new Estrada(new PVector(0, -.4f, 0), 10, 65);
  popo0 = new Carro(new PVector(0, 0, -2.5), estrada, 0, 0.2, 0.023, sistemaC[0], sistemaJC[0], color(200, 120, 0), color(100, 70, 40));
  popo1 = new Carro(new PVector(0, 0, 2.5), estrada, PI, 0.35, 0.04, sistemaC[1], sistemaJC[1], color(40, 255, 0), color(70, 255, 50));

  estradaTextura = loadImage("textura/estrada.jpg");
  estradaCantoTextura = loadImage("textura/estrada_canto.jpg");
  vidro = loadImage("textura/vidro.jpg");
  matte[0] = loadImage("textura/matte0.jpg");
  matte[1] = loadImage("textura/matte1.jpg");
  //showPredios = false;

  textureMode(NORMAL);
  textureWrap(REPEAT);
}

void draw(){
  ortho(-width * .7f, width * .7f, -height * .7f, height * .7f, -1, renderDistance);

  applyMatrix(matrixRy);
  applyMatrix(matrixEscala);

  noStroke();
  background(#212445);
  //lights();
  //eixos();
  
  lightFalloff(0.995, 0.0, 0.000001);
  ambientLight(255, 197, 255);
  lightSpecular(15, 0, 30);
  directionalLight(230, 120, 180, -1, -1, 0.5);

  pushMatrix();
  rotateY(frameCount * 0.05);
  pointLight(90, 60, 200, 0, 0, 100 * vox);
  //caixaVOX(new PVector(0, 0, 100), new PVector(10, 10, 10));
  popMatrix();

  popo0.desenhar();
  popo1.desenhar();
  
  //geração da estrada
  emissive(0, 0, 10);
  specular(0, 0, 255);
  estrada.desenhar();
  //estrada.debugPontos();

  //chão
  ambient(#0e0b17);
  emissive(2, 0, 7);
  specular(130, 0, 200);
  pushStyle();
    fill(#0e0b17);
    caixaVOX(
      new PVector(0, 5, 0),
      new PVector(100, 10.5, 100)
    );
  popStyle();

  //predio tipo 1 no bloco + proximo da camara (na pos inicial)
  predio(0, new PVector(-19, 0, 15), new float[]{17.5}, 40, sistemaP[0], sistemaJ[0],
  new int[][] {
    {1, 6},
    {1, 4},
    {1, 3},
    {1, 5}
  });
  
  //prédio tipo 1 no centro do bloco mais próximo da câmara (pos inicial)
  predio(1, new PVector(0, 0, 14), new float[]{17.5, 10}, 50, sistemaP[1], sistemaJ[1],
  new int[][] {
    {1, 7},
    {1, 7}
  });


  //dois prédios tipo 1, o mais próximo da câmara (na sua pos inicial) é o menor e magenta e tem menos janelas
  for(int i = 1; i <= 2; i++){
    float h = 30;
    int nJanelas = 4;
    if(i == 1){
      h = 40;
      nJanelas = 7;
    }
    pushMatrix();
      translacao(17, 0, 5 + 4.375 * i + 6 * (i - 1));
      rotateY(HALF_PI);
      predio(1, new PVector(0, 0, 0), new float[]{17.5, 8.75}, h, sistemaP[i - 1], sistemaJ[i - 1],
      new int[][] {
        {1, nJanelas},
        {1, nJanelas}
      });
    popMatrix();
  }

  //bloco '2' (mais afastado da camera na pos inicial)
  pushMatrix();
    rotateY(PI);
    predio(0, new PVector(-3, 0, 10), new float[]{10}, 45, sistemaP[0], sistemaJ[0],
    new int[][] {
      {1, 7},
      {1, 7},
      {1, 5},
      {1, 5}
    });
    predio(0, new PVector(-3, 0, 22), new float[]{10}, 68, sistemaP[0], sistemaJ[0],
    new int[][] {
      {1, 7},
      {1, 10},
      {1, 7},
      {1, 13}
    });
    predio(0, new PVector(-19, 0, 17), new float[]{16}, 50, sistemaP[1], sistemaJ[1],
    new int[][] {
      {1, 7},
      {1, 7},
      {1, 7},
      {1, 7}
    });
    push();
      
      tVox(new PVector(10, 0, 16.5));
      rotateY(PI);
      predio(1, new PVector(0, 0, 0), new float[]{20, 11}, 60, sistemaP[0], sistemaJ[0],
        new int[][] {
          {1, 12},
          {1, 7}
        });
      tVox(new PVector(-11.5, 0, 0));
      predio(1, new PVector(0, 0, 0), new float[]{20, 11}, 45, sistemaP[1], sistemaJ[1],
        new int[][] {
          {1, 5},
          {1, 7}
        });
    pop();
  popMatrix();
  
  
  //filter(DILATE);

  if(keys[CONTROL]){
    if(mousePressed) cursor(mao[1]);
    else cursor(mao[0]);
  }

  tiltCamera();
  yLookCamera();
  setCamera();
  manipularSP0();
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
  
  if(key == 'f' || key == 'F') printCamera();

  if(keyCode == CONTROL) cursor(ARROW);

  if(key == 'b' || key == 'B') candeeiros = !candeeiros;
}

void mouseDragged(){
  if(keys[CONTROL]){

    if(mouseButton == LEFT) theta += map(mouseX - pmouseX, 0, 1, 0, PI * 0.001f);
    else if(mouseButton == RIGHT) py -= map(mouseY - pmouseY, 0, 1, 0, 1.0f);
  }

  atualizarMatrix();
}

void mouseWheel(MouseEvent e) {
  if(e.getCount() == -1) escala *= multiEscala;
  else escala *= 1.0f / multiEscala;
  if(escala > limitesEscala[1]) escala = limitesEscala[1];
  else if(escala < limitesEscala[0]) escala = limitesEscala[0];
  atualizarMatrix();
}

void atualizarMatrix(){
  matrixRy = new PMatrix3D(
    cos(theta),  0, sin(theta), 0,
    0,           1, 0,          0,
    -sin(theta), 0, cos(theta), 0,
    0,           0, 0,          1
  );

  matrixEscala = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1.0f / escala
  );
}
