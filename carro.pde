class Carro{
    PVector pos; //posicao do carro
    Estrada E; //a estrada a ser mapeada pelo carro
    float alpha = 0; //ângulo de rotação
    float epsilon = 0; //ângulo do carro (esteticamente)
    float incremento = 0.2f; //incremento relativo à posição do carro
    float incrementoAngular = 0.05f; //incremento relativo à angulação do carro nas curvas
    float sinalIncrementoX = 1, sinalIncrementoZ = 1; //sinal do incremento
    
    boolean rodando = false; //esta booleana verifica se os carros estão ou não a fazer um canto
    int sinalRotacao = 0; //saber como o carro faz a rotação nos cantos
    boolean fim_rotacao = false; //booleano para verificar se a rotação terminou
    PontoRotacao p_deRotacao; // último/atual ponto de rotação

    float[] dims = {5, 3}; //dimensões x e z do carro
    float[] hDims = {dims[0] * 0.5f, dims[1] * 0.5f}; //metade das dimensões

    float alturaCarro = 1;
    float parametroPneu = 0.7;
    float raioPneu = alturaCarro * parametroPneu;
    float rotPneus = 0;

    SistemaCor sCarro, sJanela;
    color spotLight, specularLight;



    Carro(PVector pos, Estrada E, float epsilon, float incremento, float incrementoAngular, SistemaCor sCarro, SistemaCor sJanela, color spotLight, color specularLight){
        this.pos = pos;
        
        this.E = E;

        pos.y = -(E.hEstrada + alturaCarro);
        this.epsilon = epsilon;
        this.incremento = incremento;
        this.incrementoAngular = incrementoAngular;

        this.sCarro = sCarro;
        this.sJanela = sJanela;

        this.spotLight = spotLight;
        this.specularLight = specularLight;
    }

    void desenhar(){
        push();
            fazerCanto();
            if(fim_rotacao){
                float pX_trans = pos.x - p_deRotacao.pos.x;
                float pZ_trans = pos.z - p_deRotacao.pos.z;
                ////////////////////////////////////////////////////////////////////////
                // IMPORTANTE !!!!!!!
                ////////////////////////////////////////////////////////////////////////
                // transformar o carro relativamente à matriz de rotação Y sobre o ponto de rotação (tb a matriz de translação)
                epsilon += alpha;
                pos = new PVector(
                    cos(alpha) * pX_trans + sin(alpha) * pZ_trans + p_deRotacao.pos.x,
                    pos.y,
                    -sin(alpha) * pX_trans + cos(alpha) * pZ_trans + p_deRotacao.pos.z
                );
                fim_rotacao = false;
                alpha = 0;
            }
            
            tVox(pos);
            rotateY(epsilon);
            tVox(new PVector(-pos.x, -pos.y, -pos.z));
            push();
                translacao(pos.x + dims[0] * .5f, pos.y + raioPneu * 0.5f, pos.z);
                lightSpecular(red(specularLight), green(specularLight), blue(specularLight));
                spotLight(
                    red(spotLight), green(spotLight), blue(spotLight),
                    0, 0, 0,
                    1, 0, 0,
                    PI,
                    0.5
                );
            pop();

            //carro
            fill(sCarro.diffuse);
            emissive(sCarro.emissive);
            specular(sCarro.specular);
            ambient(sCarro.ambient);
            shininess(sCarro.shininess);
            caixaVOX(pos, new PVector(dims[0], alturaCarro, dims[1]));
            caixaTexturaVOX(
                pos,
                new PVector(dims[0], alturaCarro, dims[1]),
                new PImage[] {
                    matte[0], matte[0], matte[1], matte[1], null, null
                },
                new int[][]{
                    {1, 1}, {1, 1}, {1, 1}, {1, 1}, null, null
                }
            );
            caixaVOX(new PVector(pos.x - 0.6, pos.y - alturaCarro * 0.2 - alturaCarro * 0.6 - alturaCarro * 0.5, pos.z), new PVector(dims[0] - 1.2, alturaCarro * 0.4, dims[1]));


            //janela
            fill(sJanela.diffuse);
            emissive(sJanela.emissive);
            specular(sJanela.specular);
            ambient(sJanela.ambient);
            shininess(sJanela.shininess);
            caixaTexturaVOX(
                new PVector(pos.x - 0.8, pos.y - alturaCarro * 0.3 - alturaCarro * 0.5, pos.z),
                new PVector(dims[0] - 1.6, alturaCarro * 0.6, dims[1]),
                new PImage[] {
                    vidro, vidro, vidro, vidro, null, null
                },
                new int[][]{
                    {4, 2}, {4, 2}, {2, 5}, {2, 5}, null, null
                }
            );

            push();
                translacao(pos.x + dims[0] * .5f, pos.y , pos.z);
                caixaVOX(new PVector(-0.2, 0, 1.2), new PVector(raioPneu * 0.8, raioPneu * 0.8, raioPneu * 0.8));
                caixaVOX(new PVector(-0.2, 0, -1.2), new PVector(raioPneu * 0.8, raioPneu * 0.8, raioPneu * 0.8));
            pop();

            //pneus
            fill(20);
            ambient(20);
            emissive(0, 0, 0);
            specular(0, 0, 0);
            for(int i = 1; i <= 2; i++){
                pushMatrix();
                    translacao(pos.x + pow(-1, i) * alturaCarro * 2 * parametroPneu, pos.y + raioPneu * 0.5f, pos.z);
                    rotateZ(rotPneus);
                    caixaVOX(new PVector(0, 0, 0), new PVector(raioPneu, raioPneu, dims[1] * 1.5f));
                popMatrix();
            }
            rotPneus += 0.1f;
        pop();
        
        //Só quando não estiver a rodar perante algum dos pontos de rotação
        if(!rodando){
            //PARA DETETAR OS PONTOS
            for(int p = 0; p < E.pontos.size(); p++){
                //necessário para caso encontre um ponto para rodar, parar logo o ciclo
                if(rodando) break;

                PontoRotacao pontoEstrada = E.pontos.get(p);
                PVector posicaoPonto = pontoEstrada.pos;
                int indexPareado = pontoEstrada.indexPareado;
                float dist_pEstrada = distancia(posicaoPonto, pos);

                //inicialmente detetar os pontos de posição X positiva e se o carro os passa
                if((posicaoPonto.x > 0 && pos.x > posicaoPonto.x) || (posicaoPonto.x < 0 && pos.x < posicaoPonto.x)){
                    //ir buscar o outro ponto ao array para se escolher (se tiver a andar em X, portanto sin(epsilon) == 0)
                    boolean anda_emX = (round(sin(epsilon)*100)*0.01f == 0);
                    
                    //verificar se é pareado, se for, escolhe um aleatoriamente para fazer a mudança de direção
                    if(indexPareado != -1){
                        //ir buscar o array ao qual o ponto em causa é pareado com
                        PontoRotacao[] par = E.pontosPareados.get(indexPareado).parPontos;
                        PontoRotacao o_outro = new PontoRotacao(new PVector(0, 0, 0), -1);
                        float dist_outro;

                        for(PontoRotacao elemento : par){
                            if(pontoEstrada.pos != elemento.pos) o_outro = elemento;
                        }

                        dist_outro = distancia(o_outro.pos, pos);
                        boolean comparacao_dists = (dist_outro > dist_pEstrada);
                        
                        if(anda_emX){

                            //verificar se o Z do carro está compreendido entre os Zs dos pontos pareados
                            if(
                                (o_outro.pos.z > pos.z && pos.z > posicaoPonto.z)
                                ||
                                (o_outro.pos.z < pos.z && pos.z < posicaoPonto.z)
                            ){
                                rodando = true;
                                if(random(0, 1) < .5){
                                    p_deRotacao = o_outro;
                                    if(comparacao_dists) sinalRotacao = -1;
                                    else sinalRotacao = 1;
                                }
                                else{
                                    p_deRotacao = pontoEstrada;
                                    if(comparacao_dists) sinalRotacao = 1;
                                    else sinalRotacao = -1;
                                }
                                pos.x = posicaoPonto.x;
                            }
                        }
                        else if(
                            ((o_outro.pos.z > pos.z && posicaoPonto.z < pos.z)
                            ||
                            (o_outro.pos.z < pos.z && posicaoPonto.z > pos.z)) && comparacao_dists
                        ){
                            if(random(0, 1) < .5){
                                if(dist_pEstrada < E.largura * 0.5f) sinalRotacao = 1;
                                else sinalRotacao = -1;
                                p_deRotacao = pontoEstrada;
                                rodando = true;
                            }
                        }
                    }
                    //caso não seja pareado, é pq é um das esquinas portanto vamos verificar as componentes z das suas posições
                    else if(indexPareado == -1){
                        /*
                            caso seja positivo, ent o carro tem de ter umas pos.z maior ou igual à sua componente Z
                            //o caso contrário aplica-se da mesma maneira
                        */
                        if((posicaoPonto.z > 0 && pos.z > posicaoPonto.z) || (posicaoPonto.z < 0 && pos.z < posicaoPonto.z)){
                            if(anda_emX) pos.x = posicaoPonto.x;
                            else pos.z = posicaoPonto.z;

                            if(dist_pEstrada > E.largura * 0.5f) sinalRotacao = -1;
                            else sinalRotacao = 1;

                            p_deRotacao = pontoEstrada;
                            rodando = true;
                        }
                    }
                };
            }
        }
        
        if(!rodando) pos = new PVector(pos.x + cos(epsilon) * incremento, pos.y, pos.z - sin(epsilon) * incremento);
    }

    void fazerCanto(){
        if(rodando){
            if(
                (sinalRotacao == 1 && alpha <= sinalRotacao * HALF_PI)
                ||
                (sinalRotacao == -1 && alpha >= sinalRotacao * HALF_PI)
            ){
                tVox(p_deRotacao.pos);
                rotateY(alpha);
                tVox(new PVector(-p_deRotacao.pos.x, -p_deRotacao.pos.y, -p_deRotacao.pos.z));

                //p_deRotacao.debugLinha();
                alpha += sinalRotacao * incrementoAngular;
            }
            else{
                rodando = false;
                alpha = sinalRotacao * HALF_PI;
                sinalRotacao = 0;
                fim_rotacao = true;
            }
        }
    }
}