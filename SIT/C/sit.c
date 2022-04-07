#include <stdio.h>
#include <stdlib.h>

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

int keygen(long int seed, int * k1, int * k2, int * k3, int * k4, int * k5){
    int cat_node0 = ((seed >> 48) & 0xf000) | ((seed >> 36) & 0x0f00) | ((seed >> 24) & 0x00f0) | ((seed >> 12) & 0x000f);
    int cat_node1 = ((seed >> 44) & 0xf000) | ((seed >> 32) & 0x0f00) | ((seed >> 20) & 0x00f0) | ((seed >> 8)  & 0x000f);
    int cat_node2 = ((seed >> 40) & 0xf000) | ((seed >> 28) & 0x0f00) | ((seed >> 16) & 0x00f0) | ((seed >> 4)  & 0x000f);
    int cat_node3 = ((seed >> 36) & 0xf000) | ((seed >> 24) & 0x0f00) | ((seed >> 12) & 0x00f0) | ((seed)       & 0x000f);
    
    *k1 = f_function(cat_node0); 
    *k2 = f_function(cat_node1); 
    *k3 = f_function(cat_node2); 
    *k4 = f_function(cat_node3);
    *k5 = *k1 ^ *k2 ^ *k3 ^ *k4;
    return 0;
}

unsigned long long xnor(unsigned long long x, unsigned long long y) {
    return ~(x^y);
}

unsigned long long xor_1(unsigned long long x, unsigned long long y) {
    return x^y;
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

void baseDecrypt(unsigned long long *d1, unsigned long long *d2, unsigned long long *d3, unsigned long long *d4, int step_key){
    unsigned long long Rox1 = xnor(*d1, step_key) & 0x0ffff;
    unsigned long long Rox2 = xor_1(f_function(*d4), *d3)  & 0x0ffff;
    unsigned long long Rox4 = xnor(*d4, step_key) & 0x0ffff;
    unsigned long long Rox3 = xor_1(f_function(*d1), *d2)  & 0x0ffff;

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

unsigned long long decrypt(long long data, long int k1, long int k2, long int k3, long int k4, long int k5) {
    unsigned long long d1 = (data & 0x0ffff);
    unsigned long long d2 = ((data >> 16) & 0x0ffff);
    unsigned long long d3 = ((data >> 32) & 0x0ffff);
    unsigned long long d4 = ((data >> 48) & 0x0ffff);

    baseDecrypt(&d1, &d2, &d3, &d4, k5);
    baseDecrypt(&d2, &d1, &d4, &d3, k4);
    baseDecrypt(&d1, &d2, &d3, &d4, k3);
    baseDecrypt(&d2, &d1, &d4, &d3, k2);
    baseDecrypt(&d1, &d2, &d3, &d4, k1);
    
    unsigned long long output = (d4 << 48) | (d3 << 32) | (d2 << 16) | (d1);
    return output;
}

int main(int argc, char * argv[]){
    unsigned long long ini_seed = 0x0123456789abcdef;
    int k1, k2, k3, k4, k5;
    unsigned long long input = strtoull(argv[1], NULL, 16);
    printf("The initial message is: %lx\n", input);
    unsigned int key = keygen(ini_seed, &k1, &k2, &k3, &k4, &k5);
    unsigned long long encrypted = encrypt(input, k1, k2, k3, k4, k5);
    printf("The encrypted message is: %lx\n", encrypted);
    unsigned long long decrypted = decrypt(encrypted, k1, k2, k3, k4, k5);
    printf("The decrypted message is: %lx\n", decrypted);
    return 0;
}
