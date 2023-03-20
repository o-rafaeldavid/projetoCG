void settings(){
  size(1000, 1000, P3D);
  
}

void setup(){
  ortho(-width * .5, width * .5, -height * .5, height * .5, 0, renderDistance);
  
  camera(
  500, -500, 500,
  0, 0, 0,
  0, 1, 0);
  
}

void draw(){
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
}

void keyPressed(){
  keys[keyCode] = true;
}

void keyReleased(){
  keys[keyCode] = false;
  
  if(key == 'f' || key == 'F') printCamera();
}
