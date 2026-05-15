
#include <stdio.h>

int tokens_to_index(int* inputIndices, char* inputBuffer, char* vocabBuffer){
    
    char* actualInputWordStart = inputBuffer;
    char* actualInputChar = inputBuffer;
    char* actualVocabChar = vocabBuffer;
    int wordNr = 0;
    int size = 0;
    int* actualInputIndices = inputIndices;
    while (*actualInputChar != '\0'){
        
        if (*actualInputChar == *actualVocabChar){
             if (*actualInputChar == '\n'){
                *actualInputIndices = wordNr;
                size++;
                actualInputIndices++;
                actualVocabChar = vocabBuffer;
                actualInputChar++;
                actualInputWordStart = actualInputChar;
                
                wordNr = 0;
                continue;
            } else {
                actualInputChar++;
                actualVocabChar++;
            }

        } else {
            if (*actualVocabChar == '\n'){
                
                    actualVocabChar++;
                    actualInputChar = actualInputWordStart;
                    wordNr++;
                
            } else if (*actualVocabChar == '\0'){
                if (*actualInputChar == '\n'){
                    *actualInputIndices = wordNr;
                    size++;
                    actualInputIndices++;
                    actualVocabChar = vocabBuffer;
                    actualInputChar++;
                    actualInputWordStart = actualInputChar;
                
                    wordNr = 0;
                    continue;
                }
            }
          
             else {
                while (*actualVocabChar != '\n'){
                    actualVocabChar++;
                }
                actualVocabChar++;
                actualInputChar =actualInputWordStart;
                wordNr++;
            }
        
        }
    }
    return size;
}
int main(){
    int result[100];
char* inputBuffer = "cat\ncaterpillar\n";
char* vocabBuffer = "caterpillar\ncat\n";
    int size = tokens_to_index(result,inputBuffer,vocabBuffer);
    for (int i = 0; i < size; ++i){
        printf("%d\n",result[i]);
    }

}