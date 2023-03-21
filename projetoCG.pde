void settings(){
  size(1280, 720, P3D);
  
}

void setup(){
  ortho(-width * .7f, width * .7f, -height * .7f, height * .7f, -1, renderDistance);
  
  setCamera();
  
  mao[0] = loadImage("cursors/mao_aberta.png");
  mao[1] = loadImage("cursors/mao_fechada.png");
}

void draw(){

  applyMatrix(matrixRy);
  applyMatrix(matrixEscala);

  noStroke();
  background(#212445);
  //lights();
  eixos();
  
  
  ambientLight(255, 197, 255);
  pointLight(255, 255, 255, 70 * vox, -50 * vox, 30 * vox);
  shininess(360);

  //chão
  emissive(2, 0, 7);
  specular(130, 0, 200);
  pushStyle();
    fill(#0e0b17);
    caixaVOX(
      new PVector(0, 5, 0),
      new PVector(100, 10.5, 100)
    );
  popStyle();


  emissive(15, 0, 5);
  specular(255, 0, 255);
  predio(0, new PVector(-30, 0, -30), new float[]{17.5}, 40, color(#0a1024), color(0, 255, 255),
  new int[][] {
    {1, 7},
    {1, 7},
    {1, 7},
    {1, 7}
  });
  
  
  emissive(2, 0, 15);
  specular(100, 0, 255);
  predio(1, new PVector(0, 0, 13.75), new float[]{17.5, 10}, 40, color(#150a24), color(255, 0, 255),
  new int[][] {
    {1, 7},
    {1, 7}
  });
  

  
  push();
    emissive(0, 0, 10);
    specular(0, 0, 255);
    translacao(0, -.4, 0);
    fill(#767e8a);
    caixaVOX(
      new PVector(0, 0, 0),
      new PVector(45, .8, 10)
    );

    int in = 1, out = 1;

    do{
      rotateY(map(out, 1, 2, 0, HALF_PI));
      do{
        caixaVOX(
          new PVector(0, 0, in * 27.5),
          new PVector(45, .8, 10)
        );

        caixaVOX(
          new PVector(in * 27.5, 0, in * 27.5),
          new PVector(10, .8, 10)
        );
        in *= -1;
      }
      while(in != 1);

      out++;
    }
    while(out < 3);
    
  pop();
  
  //filter(DILATE);

  if(keys[CONTROL]){
    if(mousePressed) cursor(mao[1]);
    else cursor(mao[0]);
  }

  tiltCamera();
  yLookCamera();
  setCamera();
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
  
  if(key == 'f' || key == 'F') printCamera();

  if(keyCode == CONTROL) cursor(ARROW);
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