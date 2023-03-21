void settings(){
  size(1280, 720, P3D);
  
}

float upX = 0, upZ = 0;
void setup(){
  ortho(-width * .7f, width * .7f, -height * .7f, height * .7f, -1, renderDistance);
  
  camera(
  700, -500, 700,
  0, 0, 0,
  0, 1, 0);
  
  mao[0] = loadImage("cursors/mao_aberta.png");
  mao[1] = loadImage("cursors/mao_fechada.png");
}

void draw(){

  applyMatrix(matrizAplicavel);
  applyMatrix(matrizRX);
  applyMatrix(matrizRZ);

  noStroke();
  background(#212445);
  //lights();
  eixos();
  
  ambientLight(255, 197, 255);
  
  pointLight(255, 255, 255, 70 * vox, -50 * vox, 30 * vox);
  
  shininess(360);
  emissive(15, 0, 5);
  specular(255, 0, 255);
  predio(0, new PVector(0, 0, 0), 17, 40, color(#0a1024), color(0, 255, 255), null);
  
  emissive(2, 0, 15);
  specular(100, 0, 255);
/*
  predio(0, new PVector(0, 0, 20 * vox), 14, 50, color(#150a24), color(255, 0, 255), new int[][] {
      {1, 2},
      {0, 0},
      {1, 2},
      {1, 5}
    }
  );
*/

  predio(1, new PVector(20 * vox, 0, 0), 17, 30, color(#150a24), color(255, 0, 255), null);
  
  beginShape();
  endShape();
  
  //float[] a = {10, 10};
  //quadri(new PVector(0, 0, 0), a, new PVector(0, 0, 0));
  //caixa(new PVector(0, 0, 0), new PVector(vox, 2 * vox, 3 * vox));
  //filter(DILATE);

  if(keys[CONTROL]){
    if(mouseButton == LEFT && mousePressed) cursor(mao[1]);
    else cursor(mao[0]);
  }

  //theta += 0.01f;
  matrizRX = new PMatrix3D(
    1,  0, 0, 0,
    0, cos(psi), -sin(psi), 0,
    0, sin(psi), cos(psi), 0,
    0, 0, 0, 1
  );

  //omega += 0.01f;
  matrizRZ = new PMatrix3D(
    cos(phi),  -sin(phi), 0, 0,
    sin(phi), cos(phi), 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );

  if(keys[LEFT] || keys[RIGHT]){
    if(keys[LEFT]){
      upZ += 0.01f;
      upX -= 0.01f;
    }
    else{
      upZ -= 0.01f;
      upX += 0.01f;
    }
    camera(
    700, -500, 700,
    0,   0,    0,
    upX, 1,    upZ);
  }
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
  }

  atualizarMatrix();
}

void mouseWheel(MouseEvent e) {
  escala -= e.getCount();
  if(escala <= 0) escala = 1;
  atualizarMatrix();
}

void atualizarMatrix(){
  matrizAplicavel = new PMatrix3D(
    cos(theta),  0, sin(theta), 0,
    0,         1, 0,        0,
    -sin(theta), 0, cos(theta) , 0,
    0,         0, 0,        1.0f / escala
  );
}