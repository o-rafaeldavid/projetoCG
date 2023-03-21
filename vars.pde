boolean[] keys = new boolean[255]; //saber que keys estão a ser primidas (isto premite saber se estão a ser primidas ao mesmo tempo)

float vox = 10; //unidade base do projeto

float renderDistance = 1000 * vox;


float escala = 1;
float psi = 0, theta = 0, phi = 0;

PMatrix3D matrizAplicavel = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
);

PMatrix3D matrizRX = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
);  

PMatrix3D matrizRZ = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
);  

PImage[] mao = new PImage[2]; 