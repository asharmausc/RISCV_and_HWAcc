#include <stdio.h>
#include <stdlib.h>

/*
int Q(int data){
                 //     0   1  2  3  4   5  6  7   8   9  10   11  12  13 14   15
    int Q_table [16] = {9, 14, 5, 6, 10, 2, 3, 12, 15, 0, 4,   13,  7, 11,  1,  8};
    return Q_table[data];
}
int P(int data){
                //     0   1   2   3  4  5   6   7   8   9  10  11  12  13  14  15
    int P_table [16] = {3, 15, 14, 0, 5, 4, 11, 12, 13, 10, 9,   6,  7,  8,  2,  1};
    return P_table[data];
}

unsigned long long xnor(unsigned long long x, unsigned long long y) {
    return ~(x^y);
}

unsigned long long xor_1(unsigned long long x, unsigned long long y) {
    return x^y;
}

unsigned long long f_function(unsigned long long data16){
    unsigned long long P10 = P(data16>>12);
    unsigned long long Q10 = Q(data16>>8  & 0x000f);
    unsigned long long P20 = P(data16>>4  & 0x000f);
    unsigned long long Q20 = Q(data16     & 0x000f);

    unsigned long long Q11 = Q((P10 & 0b1100) | (Q10 >> 2));
    unsigned long long P11 = P(((P10 << 2) | (P20 >> 2)) & 0x0f);
    unsigned long long Q21 = Q(((Q10 << 2) | (Q20 >> 2)) & 0x0f);
    unsigned long long P21 = P((Q20 & 0b0011) | ((P20 << 2) & 0b1100));

    unsigned long long P12 = P((Q11 & 0b1100) | (P11 >> 2));
    unsigned long long Q12 = Q(((Q11 << 2) | (Q21 >> 2)) & 0x0f);
    unsigned long long P22 = P(((P11 << 2) | (P21 >> 2)) & 0x0f);
    unsigned long long Q22 = Q((P21 & 0b0011) | ((Q21 << 2) & 0b1100));

    unsigned long long out_data = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;
    return out_data;
} 

void baseEncrypt(unsigned long long *d1, unsigned long long *d2, unsigned long long *d3, unsigned long long *d4, int step_key){
    unsigned long long Rox1 = xnor(*d1, step_key) & 0x0ffff;
    unsigned long long Rox2 = xor_1(f_function(Rox1), *d3)  & 0x0ffff;
    unsigned long long Rox4 = xnor(*d4, step_key) & 0x0ffff;
    unsigned long long Rox3 = xor_1(f_function(Rox4), *d2)  & 0x0ffff;

    *d1 = Rox1;
    *d2 = Rox2;
    *d3 = Rox3;
    *d4 = Rox4;
}

unsigned long long encrypt(long long data, long int k1, long int k2, long int k3, long int k4, long int k5) {
    unsigned long long d1 = (data & 0x0ffff);
    unsigned long long d2 = ((data >> 16) & 0x0ffff);
    unsigned long long d3 = ((data >> 32) & 0x0ffff);
    unsigned long long d4 = ((data >> 48) & 0x0ffff);

    baseEncrypt(&d1, &d2, &d3, &d4, k1);
    baseEncrypt(&d2, &d1, &d4, &d3, k2);
    baseEncrypt(&d1, &d2, &d3, &d4, k3);
    baseEncrypt(&d2, &d1, &d4, &d3, k4);
    baseEncrypt(&d1, &d2, &d3, &d4, k5);    
    
    unsigned long long output = (d4 << 48) | (d3 << 32) | (d2 << 16) | (d1);
    return output;
}

*/
int main(int argc, char * argv[]){

    //F-function: P/Q Tables
    int P[16] = {3, 15, 14, 0,  5, 4, 11, 12, 13, 10, 9,  6, 7,  8, 2, 1};
    int Q[16] = {9, 14,  5, 6, 10, 2,  3, 12, 15,  0, 4, 13, 7, 11, 1, 8};

    //Input message from command line
    unsigned long long input = strtoull(argv[1], NULL, 16);
    printf("The initial message is: %lx\n", input);

    //Encryption
    unsigned long long d1_0 = (input & 0x0ffff);
    unsigned long long d2_0 = ((input >> 16) & 0x0ffff);
    unsigned long long d3_0 = ((input >> 32) & 0x0ffff);
    unsigned long long d4_0 = ((input >> 48) & 0x0ffff);

    unsigned long long d1_1;
    unsigned long long d2_1;
    unsigned long long d4_1;
    unsigned long long d3_1;

    unsigned long long d1_1_f;
    unsigned long long d4_1_f;

    unsigned long long P10, Q10, P20, Q20;
    unsigned long long P11, Q11, P21, Q21;
    unsigned long long P12, Q12, P22, Q22;

    //key array
    int k[5] = {0x0123, 0x4567, 0x89ab, 0xcdef, 0x0123};

    //5 round encryption
    for (int i = 0; i < 5; i++) {
        d1_1 = ~(d1_0 ^ k[i]) & 0x0ffff;

        P10 = P[d1_1>>12];
        Q10 = Q[d1_1>>8  & 0x000f];
        P20 = P[d1_1>>4  & 0x000f];
        Q20 = Q[d1_1     & 0x000f];
        Q11 = Q[(P10 & 0b1100) | (Q10 >> 2)];
        P11 = P[((P10 << 2) | (P20 >> 2)) & 0x0f];
        Q21 = Q[((Q10 << 2) | (Q20 >> 2)) & 0x0f];
        P21 = P[(Q20 & 0b0011) | ((P20 << 2) & 0b1100)];
        P12 = P[(Q11 & 0b1100) | (P11 >> 2)];
        Q12 = Q[((Q11 << 2) | (Q21 >> 2)) & 0x0f];
        P22 = P[((P11 << 2) | (P21 >> 2)) & 0x0f];
        Q22 = Q[(P21 & 0b0011) | ((Q21 << 2) & 0b1100)];

        d1_1_f = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;

        d2_1 = (d1_1_f ^ d3_0)  & 0x0ffff;
        d4_1 = ~(d4_0 ^ k[i]) & 0x0ffff;

        P10 = P[d4_1>>12];
        Q10 = Q[d4_1>>8  & 0x000f];
        P20 = P[d4_1>>4  & 0x000f];
        Q20 = Q[d4_1     & 0x000f];
        Q11 = Q[(P10 & 0b1100) | (Q10 >> 2)];
        P11 = P[((P10 << 2) | (P20 >> 2)) & 0x0f];
        Q21 = Q[((Q10 << 2) | (Q20 >> 2)) & 0x0f];
        P21 = P[(Q20 & 0b0011) | ((P20 << 2) & 0b1100)];
        P12 = P[(Q11 & 0b1100) | (P11 >> 2)];
        Q12 = Q[((Q11 << 2) | (Q21 >> 2)) & 0x0f];
        P22 = P[((P11 << 2) | (P21 >> 2)) & 0x0f];
        Q22 = Q[(P21 & 0b0011) | ((Q21 << 2) & 0b1100)];

        d4_1_f = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;

        d3_1 = (d4_1_f ^ d2_0)  & 0x0ffff;

        d1_0 = d2_1;
        d2_0 = d1_1;
        d3_0 = d4_1;
        d4_0 = d3_1;
    }

    unsigned long long output = (d4_1 << 48) | (d3_1 << 32) | (d2_1 << 16) | (d1_1);

    printf("The loop encrypted message is: %lx\n", output);
    //printf("The encrypted message is: %lx\n", encrypt(input, k[0], k[1], k[2], k[3], k[4]));

    return 0;
}
