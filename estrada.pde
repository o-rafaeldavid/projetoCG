class Estrada{
    PVector pos;
    float largura, dimensao;
    float hEstrada = .8;

    ArrayList<PontoRotacao> pontos = new ArrayList<PontoRotacao>();
    ArrayList<DuplaPontos>  pontosPareados   = new ArrayList<DuplaPontos>();

    Estrada(PVector pos, float largura, float dimensao){
        this.pos = pos;
        this.largura = largura;
        this.dimensao = dimensao;

        float cornerX = (dimensao - largura) * .5;
        float[] cornerZ = {largura * .5, cornerX};

        //criar os pontos pareados
        pontosPareados.add(new DuplaPontos(
            new PVector(cornerX, -hEstrada, cornerZ[0]),
            new PVector(cornerX, -hEstrada, -cornerZ[0])
        ));

        pontosPareados.add(new DuplaPontos(
            new PVector(-cornerX, -hEstrada, -cornerZ[0]),
            new PVector(-cornerX, -hEstrada, cornerZ[0])
        ));

        //adicionar os pontos pareados à lista de pontos
        for(int pares = 0; pares < pontosPareados.size(); pares++){
            PVector P = pontosPareados.get(pares).parPontos[0].pos;
            PVector Q = pontosPareados.get(pares).parPontos[1].pos;
            pontos.add(new PontoRotacao(P, pares));
            pontos.add(new PontoRotacao(Q, pares));
        }        

        //adicionar os pontos q são mm singulares (indice -1)
        pontos.add(new PontoRotacao(new PVector(-cornerX, -hEstrada,  cornerZ[1]), -1));
        pontos.add(new PontoRotacao(new PVector(-cornerX, -hEstrada, -cornerZ[1]), -1));
        pontos.add(new PontoRotacao(new PVector(cornerX,  -hEstrada, -cornerZ[1]), -1));
        pontos.add(new PontoRotacao(new PVector(cornerX,  -hEstrada,  cornerZ[1]), -1));
    }

    void desenhar(){
        push();
            tVox(pos);
            ambient(128);
            fill(#767e8a);
            emissive(7, 4, 7);
            specular(8, 2, 10);

            caixaTexturaVOX(
                new PVector(0, 0, 0),
                new PVector(dimensao - largura, hEstrada, largura),
                new PImage[] {
                    null, null, null, null, null, estradaTextura
                },
                new int[][]{
                    null, null, null, null, null, {1, 3}
                }
            );

            int in = 1, out = 1;

            do{
                rotateY(map(out, 1, 2, 0, HALF_PI));
                do{
                    caixaTexturaVOX(
                        new PVector(0, 0, in * dimensao * 0.5f),
                        new PVector(dimensao - largura, hEstrada, largura),
                        new PImage[] {
                            null, null, null, null, null, estradaTextura
                        },
                        new int[][]{
                            null, null, null, null, null, {1, 3}
                        }
                    );

                    

                    caixaTexturaVOX(
                        new PVector(in * dimensao * 0.5f, 0, in * dimensao * 0.5f),
                        new PVector(largura, hEstrada, largura),
                        new PImage[] {
                            null, null, null, null, null, estradaCantoTextura
                        },
                        new int[][]{
                            null, null, null, null, null, {in, in}
                        }
                    );

                    in *= -1;
                }
                while(in != 1);

                out++;
            }
            while(out < 3);

            /*
            pointLight(0, 0, 255,
                -1 * (dimensao + largura) * 0.5f * vox, -2 * vox, -1 * (dimensao + largura) * 0.5f * vox
            );
            */
            candeeiroVOX(
                new PVector(-1 * (dimensao + largura) * 0.5f, 0, -1 * (dimensao + largura) * 0.5f),
                6,
                1
            );
            
        pop();
    }

    //para ver os pontos de rotação
    void debugPontos(){
        for(int i = 0; i < pontos.size(); i++){
            pontos.get(i).debug();
        }
    }
}


//Pontos pelos quais os carros farão uma rotação para mudar de direção
class PontoRotacao{
    PVector pos;
    int indexPareado = -1;

    /*
        construtor do ponto de rotação dentro da estrada
        (o index pareado -1 indica q n tem par, enqt q se for >= 0 indica
        o indice dentro de uma ArrayList de duplas de pontos ao qual pertence)
    */
    PontoRotacao(PVector pos, int indexPareado){
        this.pos = pos;
        this.indexPareado = indexPareado;
    }

    void debug(){
        pushStyle();
            strokeWeight(10);
            stroke(255, 0, 0);
            ponto(pos.x, pos.y, pos.z);
        popStyle();
    }

    void debugLinha(){
        pushStyle();
            strokeWeight(4);
            stroke(0, 255, 255);
            linha(pos.x, pos.y, pos.z, pos.x, pos.y - 10, pos.z);
        popStyle();
    }
}

class DuplaPontos{
    PontoRotacao[] parPontos = new PontoRotacao[2];

    DuplaPontos(PVector pos0, PVector pos1){
        parPontos[0] = new PontoRotacao(pos0, -1);
        parPontos[1] = new PontoRotacao(pos1, -1);
    }

    void debug(){
        parPontos[0].debug();
        parPontos[1].debug();
    }
}