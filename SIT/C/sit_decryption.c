#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[]){
    
    //F-function: P/Q Tables
    int P[16] = {3, 15, 14, 0,  5, 4, 11, 12, 13, 10, 9,  6, 7,  8, 2, 1};
    int Q[16] = {9, 14,  5, 6, 10, 2,  3, 12, 15,  0, 4, 13, 7, 11, 1, 8};

    //Input message from command line
    unsigned long long input = strtoull(argv[1], NULL, 16);
    printf("The initial message is: %lx\n", input);

    unsigned long long d1_0 = (input & 0x0ffff);
    unsigned long long d2_0 = ((input >> 16) & 0x0ffff);
    unsigned long long d3_0 = ((input >> 32) & 0x0ffff);
    unsigned long long d4_0 = ((input >> 48) & 0x0ffff);

    unsigned long long d1_1;
    unsigned long long d2_1;
    unsigned long long d4_1;
    unsigned long long d3_1;

    unsigned long long d1_0_f;
    unsigned long long d4_0_f;

    unsigned long long P10, Q10, P20, Q20;
    unsigned long long P11, Q11, P21, Q21;
    unsigned long long P12, Q12, P22, Q22;

    //key array
    int k[5] = {0x0123, 0x4567, 0x89ab, 0xcdef, 0x0123};

    //5 round decryption
    for (int i = 4; i >= 0; i--) {
        d1_1 = ~(d1_0 ^ k[i]) & 0x0ffff;

        P10 = P[d4_0>>12];
        Q10 = Q[d4_0>>8  & 0x000f];
        P20 = P[d4_0>>4  & 0x000f];
        Q20 = Q[d4_0     & 0x000f];
        Q11 = Q[(P10 & 0b1100) | (Q10 >> 2)];
        P11 = P[((P10 << 2) | (P20 >> 2)) & 0x0f];
        Q21 = Q[((Q10 << 2) | (Q20 >> 2)) & 0x0f];
        P21 = P[(Q20 & 0b0011) | ((P20 << 2) & 0b1100)];
        P12 = P[(Q11 & 0b1100) | (P11 >> 2)];
        Q12 = Q[((Q11 << 2) | (Q21 >> 2)) & 0x0f];
        P22 = P[((P11 << 2) | (P21 >> 2)) & 0x0f];
        Q22 = Q[(P21 & 0b0011) | ((Q21 << 2) & 0b1100)];

        d4_0_f = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;

        d2_1 = (d4_0_f ^ d3_0)  & 0x0ffff;
        d4_1 = ~(d4_0 ^ k[i]) & 0x0ffff;

        P10 = P[d1_0>>12];
        Q10 = Q[d1_0>>8  & 0x000f];
        P20 = P[d1_0>>4  & 0x000f];
        Q20 = Q[d1_0     & 0x000f];
        Q11 = Q[(P10 & 0b1100) | (Q10 >> 2)];
        P11 = P[((P10 << 2) | (P20 >> 2)) & 0x0f];
        Q21 = Q[((Q10 << 2) | (Q20 >> 2)) & 0x0f];
        P21 = P[(Q20 & 0b0011) | ((P20 << 2) & 0b1100)];
        P12 = P[(Q11 & 0b1100) | (P11 >> 2)];
        Q12 = Q[((Q11 << 2) | (Q21 >> 2)) & 0x0f];
        P22 = P[((P11 << 2) | (P21 >> 2)) & 0x0f];
        Q22 = Q[(P21 & 0b0011) | ((Q21 << 2) & 0b1100)];

        d1_0_f = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;

        d3_1 = (d1_0_f ^ d2_0)  & 0x0ffff;

        d1_0 = d2_1;
        d2_0 = d1_1;
        d3_0 = d4_1;
        d4_0 = d3_1;
    }

    unsigned long long output = (d4_1 << 48) | (d3_1 << 32) | (d2_1 << 16) | (d1_1);

    printf("The decrypted message is: %lx\n", output);

    return 0;
}
