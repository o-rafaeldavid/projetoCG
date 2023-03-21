boolean[] keys = new boolean[255]; //saber que keys estão a ser primidas (isto premite saber se estão a ser primidas ao mesmo tempo)

float vox = 10; //unidade base do projeto

float renderDistance = 1000 * vox;

float incPY = 0.01f, incYLook = 3;
float py = -500, yLookAt = 0; //variavel posição y camera e posição y para onde olha
float upX = 0, upZ = 0; //variaveis para criar uma rotação da câmera perante o eixo de observação (tilt)
float[] limitesUp = {0, 0.5}; //limites relativos ao tilt (upX e upZ)

float escala = 1; //ao escalar (dar zoom) (matrixEscala)
float multiEscala = 1.2; // definir o incremento (multiplicador) de escala
float[] limitesEscala = {0.3, 5}; //limites de escala
float psi = 0, theta = 0, phi = 0; //ângulos Eulerianos (x:psi y:theta z:phi)

PMatrix3D matrixRy = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
);

PMatrix3D matrixEscala = new PMatrix3D(
    1,  0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
);

PImage[] mao = new PImage[2]; 