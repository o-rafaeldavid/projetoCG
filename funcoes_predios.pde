void predio(int nPredio, PVector P, float quadLen, float altura, color corPredio, color corJanelas, int[][] janelas){
  float half_quadLen = quadLen * 0.5;
  int distancia = 2;

  pushMatrix();
    t(P);

    //
    // OBS: no ponto de vista de preformance de código, é preferível haver 'if-elses' com ciclos analogamente repetitivos dentro dos mesmos,
    // em vez de haver os ciclos com o 'if-elses' dentro dos mesmos
    //

    // ==========================================================================
    // ==========================================================================
    // PRÉDIO
    // #0
    // ==========================================================================
    // ==========================================================================
    if(nPredio == 0){

      /*
        j e lj são distânciadas por 'distancia' (2) das arestas

        uso prático: na janela '1' (primeira janela), a face tem altura 'altura' enqt q o ponto mais alto da janela será em y = 'altura - distancia' (j),
        enqt q o ponto com maior em z será z = 'half_quadLen - distancia'
      */
      float j = altura - distancia;
      float lj = half_quadLen - distancia;
      /*
        as janelas são definidas através deste array bi-dimensional
        (o primeiro valor ou é 0 ou é 1 e identifica se não há ou se há janelas, respetivamente,
        ao passo que o segundo valor diz quantas janelas há)
      */
      if(janelas == null){
        janelas = new int[][] {
          {1, 3}, //primeira face: tem janelas e são 3
          {0, 0},
          {1, 2}, //terceira face: tem janelas e são 2
          {1, 4}  //quarta   face: tem janelas e são 4
        };
      }
      
      
      //
      // Geração das Faces e das Bases
      //
      pushStyle();
        fill(corPredio);
        //stroke(0);

        //geração das faces
        for(int face = 0; face < 4; face++){
          pushMatrix();
            //rotate para girar xD // para fazer as faces no mesmo referêncial e só rodar perante a matriz Ry
            rotateY(HALF_PI * face);
            translacao(half_quadLen, 0, 0);

            //
            // >>>> GERAÇÃO DE JANELAS
            //
            if(janelas[face][0] == 1){
              for(int i = 0; i < janelas[face][1]; i++){
                pushMatrix();
                  translacao(0, -j, 0);
                  float k = i * 4;
                  //DEPTH DAS JANELAS
                  for(int g = 0; g < 2; g++){
                    // > depths baixo e cima
                    pushMatrix();
                      float yJanelaDepth = distancia + k - 2 * g;
                      translacao(0, yJanelaDepth, 0);
                      beginShape();
                        vertice(0,  0,  lj);
                        vertice(-1, 0,  lj);
                        vertice(-1, 0, -lj);
                        vertice(0,  0, -lj);
                      endShape(CLOSE);
                    popMatrix();
                    // > depths laterais
                    pushMatrix();
                      float spotDepthLateral = pow(-1, g + 1) * lj;
                      translacao(0, 0, spotDepthLateral);
                      beginShape();
                        vertice(0,  distancia + k, 0);
                        vertice(-1, distancia + k, 0);
                        vertice(-1, k,     0);
                        vertice(0,  k,     0);
                      endShape(CLOSE);
                    popMatrix();
                  }
                  // > vidro
                  pushStyle();
                    fill(corJanelas);
                    /*
                    pointLight(0, 255, 255, vox, 2 + k, lj);
                    pointLight(0, 255, 255, vox, k, lj);
                    pointLight(0, 255, 255, vox, k, -lj);
                    pointLight(0, 255, 255, vox, 2 + k, -lj);
                    */
                    pushMatrix();
                      float depthVidro = -1;
                      translacao(depthVidro, 0, 0);
                      beginShape();
                        vertice(0,  distancia + k, lj);
                        vertice(0, k,      lj);
                        vertice(0, k,     -lj);
                        vertice(0, distancia + k, -lj);
                      endShape(CLOSE);
                    popMatrix();
                  popStyle();
                popMatrix();
              }
            }
            
            
            
            
            
            beginShape();
              vertice(0, 0, half_quadLen);
              vertice(0, -altura, half_quadLen);
              vertice(0, -altura, -half_quadLen);
              vertice(0, 0, -half_quadLen);
              
              
              if(janelas[face][0] == 1){
                for(int i = 0; i < janelas[face][1]; i++){
                  float k = i * 4;
                  //por alguma razão, não dá para aplicar o translate num contour, ou dá erro sla (provavelmente pq n funciona um translate dentro de um beginshape
                  beginContour();
                    vertice(0, -j + 2 + k, -lj);
                    vertice(0, -j + k,     -lj);
                    vertice(0, -j + k,     lj);
                    vertice(0, -j + 2 + k, lj);
                  endContour();
                }
              }
            endShape(CLOSE);
            
          popMatrix();
        }
        


        //geração das bases
        for(int base = 0; base < 2; base++){
          pushMatrix();
            translacao(0, (1 - pow(-1, base)) * 0.5 * -altura, 0);
            quadriVOX(new PVector(0, 0, 0), new float[] {quadLen, quadLen}, new PVector(0, 0, 0));
          popMatrix();
        }
      popStyle();
    }
    // ==========================================================================
    // ==========================================================================
    // PRÉDIO
    // #1
    // ==========================================================================
    // ==========================================================================
    else if(nPredio == 1){
      pushStyle();
        fill(255, 0, 0);
        //stroke(0);
        float[] lado = {quadLen - 3 * distancia, quadLen};
        float[] half_lado = {lado[0] * 0.5, lado[1] * 0.5};

        if(janelas == null){
          janelas = new int[][] {
            {1, 4},
            {1, 4}
          };
        }

        //
        // Geração das Faces e das Bases
        //

        //geração das bases
        for(int base = 0; base < 2; base++){
          pushMatrix();
            translacao(0, (1 - pow(-1, base)) * 0.5 * -altura, 0);
            quadriVOX(new PVector(0, 0, 0), new float[]{lado[0], lado[1]}, new PVector(0, 0, 0));
          popMatrix();
        }



        fill(0, 255, 0);

        //geração das laterais com janelas
        for(int laterais = 0; laterais < 2; laterais++){
          if(janelas[laterais][0] == 1){
            pushMatrix();
              rotateY(PI * laterais);
              translacao(0, 0, -half_lado[1]);
              beginShape();
                vertice(-half_lado[0], 0,       0);
                vertice(half_lado[0],  0,       0);
                vertice(half_lado[0],  -altura, 0);
                vertice(-half_lado[0], -altura, 0);

                for(int i = 0; i < janelas[laterais][1]; i++){
                  float k = i * 4;
                  beginContour();
                    vertice(-half_lado[0], -altura + distancia + k,     0);
                    vertice(half_lado[0],  -altura + distancia + k,     0);
                    vertice(half_lado[0],  -altura + 2 * distancia + k, 0);
                    vertice(-half_lado[0], -altura + 2 * distancia + k, 0);
                  endContour();
                }
              endShape(CLOSE);
              
            popMatrix();
          }
        }
      popStyle();
    }
  popMatrix();
}