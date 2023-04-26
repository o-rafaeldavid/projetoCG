void predio(int nPredio, PVector Q, float[] dimsBase, float altura, SistemaCor sPredio, SistemaCor sJanela, int[][] janelas){
  PVector P = new PVector(Q.x * vox, Q.y * vox, Q.z * vox);

  float quadLen = dimsBase[0];
  float half_quadLen = quadLen * 0.5;
  int distancia = 2;
  int half_distancia = distancia / 2;

  float gapCimaJanela = -altura + distancia;
  float half_gapCimaJanela = -half_quadLen + distancia;
  /*
    gapCimaJanela e -half_gapCimaJanela são distânciadas por 'distancia' (2) das arestas

    uso prático: na janela '1' (primeira janela), a face tem altura 'altura' enqt q o ponto mais alto da janela será em y = 'altura - distancia' (gapCimaJanela),
    enqt q o ponto com maior em z será z = 'half_quadLen - distancia' (caso predio 0)
  */

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
    if(nPredio == 0 && showPredios){
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
        fill(sPredio.diffuse);
        emissive(sPredio.emissive);
        specular(sPredio.specular);
        ambient(sPredio.ambient);
        shininess(sPredio.shininess);
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
                  translacao(0, gapCimaJanela, 0);
                  int k = i * 4;
                  //DEPTH DAS JANELAS
                  for(int g = 0; g < 2; g++){
                    // > depths baixo e cima
                    pushMatrix();
                      float yJanelaDepth = distancia + k - 2 * g;
                      translacao(0, yJanelaDepth, 0);
                      beginShape();
                        vertice(0,  0,  -half_gapCimaJanela);
                        vertice(-1, 0,  -half_gapCimaJanela);
                        vertice(-1, 0, half_gapCimaJanela);
                        vertice(0,  0, half_gapCimaJanela);
                      endShape(CLOSE);
                    popMatrix();
                    // > depths laterais
                    pushMatrix();
                      float spotDepthLateral = pow(-1, g + 1) * -half_gapCimaJanela;
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
                    fill(sJanela.diffuse);
                    emissive(sJanela.emissive);
                    specular(sJanela.specular);
                    ambient(sJanela.ambient);
                    shininess(sJanela.shininess);
                    pushMatrix();
                      float depthVidro = -1;
                      translacao(depthVidro, 0, 0);
                      beginShape();
                        vertice(0,  distancia + k, -half_gapCimaJanela);
                        vertice(0, k,      -half_gapCimaJanela);
                        vertice(0, k,     half_gapCimaJanela);
                        vertice(0, distancia + k, half_gapCimaJanela);
                      endShape(CLOSE);
                    popMatrix();
                  popStyle();
                popMatrix();
              }
            }
            
            
            
            
            emissive(sPredio.emissive);
            specular(sPredio.specular);
            ambient(sPredio.ambient);
            shininess(sPredio.shininess);
            beginShape();
              vertice(0, 0, half_quadLen);
              vertice(0, -altura, half_quadLen);
              vertice(0, -altura, -half_quadLen);
              vertice(0, 0, -half_quadLen);
              
              
              if(janelas[face][0] == 1){
                for(int i = 0; i < janelas[face][1]; i++){
                  int k = i * 4;
                  //por alguma razão, não dá para aplicar o translate num contour, ou dá erro sla (provavelmente pq n funciona um translate dentro de um beginshape
                  beginContour();
                    vertice(0, gapCimaJanela + 2 + k, half_gapCimaJanela);
                    vertice(0, gapCimaJanela + k,     half_gapCimaJanela);
                    vertice(0, gapCimaJanela + k,     -half_gapCimaJanela);
                    vertice(0, gapCimaJanela + 2 + k, -half_gapCimaJanela);
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
    else if(nPredio == 1 && showPredios){
      emissive(sPredio.emissive);
      specular(sPredio.specular);
      ambient(sPredio.ambient);
      shininess(sPredio.shininess);
      pushStyle();
        fill(sPredio.diffuse);
        //noFill();
        //stroke(0);
        float[] lado = {dimsBase[1], quadLen};
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


        /////////////////////////////////////////////////////////////////////////////
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

                //geração dos buracos das janelas
                for(int i = 0; i < janelas[laterais][1]; i++){
                  int k = i * 4;
                  float gapBase = gapCimaJanela + k;
                  beginContour();
                    vertice(-half_lado[0], gapBase,     0);
                    vertice(half_lado[0],  gapBase,     0);
                    vertice(half_lado[0],  gapBase + distancia, 0);
                    vertice(-half_lado[0], gapBase + distancia, 0);
                  endContour();
                }
              endShape(CLOSE);

              //depth das Janelas laterais
              for(int depthJanelas = 0; depthJanelas < janelas[laterais][1]; depthJanelas++){
                float k = depthJanelas * 4;
                for(int c = 1; c <= 2; c++){
                  float yDepth = -altura + c * distancia + k;
                  pushMatrix();
                    translacao(0, yDepth, 0);
                    beginShape();
                      vertice(half_lado[0],  0, 0);
                      vertice(half_lado[0],  0, distancia);
                      vertice(half_lado[0] - half_distancia,  0, distancia);
                      vertice(half_lado[0] - half_distancia,  0, half_distancia);

                      vertice(-half_lado[0] + half_distancia,  0, half_distancia);
                      vertice(-half_lado[0] + half_distancia,  0, distancia);
                      vertice(-half_lado[0], 0, distancia);
                      vertice(-half_lado[0], 0, 0);
                    endShape(CLOSE);
                  popMatrix();

                  float centerPosX = pow(-1, c) * (half_lado[0] + (half_lado[0] - half_distancia)) * 0.5f;
                  float centerPosY = -altura + 1.5f * distancia + k;
                  pushMatrix();
                    quadriVOX(new PVector(centerPosX, centerPosY, distancia), new float[]{half_distancia, distancia}, new PVector(HALF_PI, 0, 0));
                  popMatrix();
                }
              }

              /////////////////
              //geração da continuação das paredes das laterais para as "frentes"
              for(int frentes = 0; frentes < 2; frentes++){
                pushMatrix();
                  translacao(pow(-1, frentes) * half_lado[0], 0, 0);
                  beginShape();

                    //meia parede
                    vertice(0, 0,       0);
                    vertice(0, 0,       half_lado[1]);
                    vertice(0, -altura, half_lado[1]);
                    vertice(0, -altura, 0);

                    
                    //geração dos buracos das janelas (nas frentes) (numa ponta)
                    for(int i = 0; i < janelas[laterais][1]; i++){
                      float k = i * 4;
                      float gapBase = gapCimaJanela + k;
                      beginContour();
                        vertice(0, gapBase,             0);
                        vertice(0, gapBase,             distancia);
                        vertice(0, gapBase + distancia, distancia);
                        vertice(0, gapBase + distancia, 0);
                      endContour();
                    }

                    // buraco central da parede (na outra ponta da meia parede)
                    float[] z_buraco = {half_lado[1] - 3 * half_distancia, half_lado[1] - half_distancia};
                    beginContour();
                      vertice(0, 0,                   z_buraco[1]);
                      vertice(0, 0,                   z_buraco[0]);
                      vertice(0, gapCimaJanela, z_buraco[0]);
                      vertice(0, gapCimaJanela, z_buraco[1]);
                    endContour();
                  endShape(CLOSE);

                  //depth do buraco central da meia parede
                  pushStyle();
                  float x_DepthBuracoFrente = pow(-1, frentes - 1) * half_distancia;
                  beginShape(QUADS);
                    vertice(0,                   0,             z_buraco[0]);
                    vertice(x_DepthBuracoFrente, 0,             z_buraco[0]);
                    vertice(x_DepthBuracoFrente, gapCimaJanela, z_buraco[0]);
                    vertice(0                  , gapCimaJanela, z_buraco[0]);

                    vertice(0                  , gapCimaJanela, z_buraco[0]);
                    vertice(x_DepthBuracoFrente, gapCimaJanela, z_buraco[0]);
                    vertice(x_DepthBuracoFrente, gapCimaJanela, z_buraco[1]);
                    vertice(0                  , gapCimaJanela, z_buraco[1]);

                    
                    vertice(0                  , gapCimaJanela, z_buraco[1]);
                    vertice(x_DepthBuracoFrente, gapCimaJanela, z_buraco[1]);
                    vertice(x_DepthBuracoFrente, 0            , z_buraco[1]);
                    vertice(0                  , 0            , z_buraco[1]);
                  endShape();
                  popStyle();
                popMatrix();
              }
            popMatrix();
          }
        }

        //caixa que define a 'janela' (cor)
        pushStyle();
          fill(sJanela.diffuse);
          ambient(sJanela.ambient);
          emissive(sJanela.emissive);
          specular(sJanela.specular);
          shininess(sJanela.shininess);
          caixaVOX(new PVector(0, -altura * 0.5f, 0), new PVector(lado[0] - distancia, altura - distancia, lado[1] - distancia));
        popStyle();
      popStyle();
    }
  popMatrix();
}