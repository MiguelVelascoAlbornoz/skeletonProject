#define CONST_DIMENSION 4

// [ [1,1,1] [2,2,2] [3,3,3]      ]

void build_input_embeddings_matrix(int* outputMatrix, int* vocabEmbeddingsMatrix, int* inputIndices,int inputTokensCount){
    int i = 0;
    while (i <inputTokensCount){
        int indice = *(inputIndices+i);
        int* embedding = vocabEmbeddingsMatrix+indice*CONST_DIMENSION;
        int j = 0;
        while (j < CONST_DIMENSION){
            *outputMatrix = *embedding;
            outputMatrix++;
            embedding++;
            j++;
        }
        i++;
    }
}