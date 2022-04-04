//P_table [16] = {3, 15, 14, 0, 5, 4, 11, 12, 13, 10, 9, 6, 7, 8, 2, 1};
//Q_table [16] = {9, 14, 5, 6, 10, 2, 3, 12, 15, 0, 4, 13, 7, 11, 1, 8};

#include <stdio.h>

// generating a Key

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

int f_function(int data16){

    //0xABCD
    int P10 = P(data16>>12);
    //0x000A   -> 9 -> 1001
    int Q10 = Q(data16>>8  & 0x000f);
    //0x000B  -> D -> 1101
    int P20 = P(data16>>4  & 0x000f);
    //0x000C  -> 7 -> 0111
    int Q20 = Q(data16     & 0x000f);
    //0x000D  -> B -> 1011
    
    //printf("1: %x\n", P10);
    //printf("2: %x\n", Q10);
    //printf("3: %x\n", P20);
    //printf("4: %x\n", Q20);   

    int Q11 = Q((P10 & 0b1100) | (Q10 >> 2));
    //1011 (B) -> D 1101
    int P11 = P(((P10 << 2) | (P20 >> 2)) & 0x0f);
    //0101 (5) -> 4 0100
    int Q21 = Q(((Q10 << 2) | (Q20 >> 2)) & 0x0f);
    //0110 (6) -> 3 0011
    int P21 = P((Q20 & 0b0011) | ((P20 << 2) & 0b1100));
    //1111 (F) -> 1 0001

    //printf("1: %x\n", Q11);
    //printf("2: %x\n", P11);
    //printf("3: %x\n", Q21);
    //printf("4: %x\n", P21);

    int P12 = P((Q11 & 0b1100) | (P11 >> 2));
    //1101 -> 8
    int Q12 = Q(((Q11 << 2) | (Q21 >> 2)) & 0x0f);
    //0100 -> A
    int P22 = P(((P11 << 2) | (P21 >> 2)) & 0x0f);
    //0000 -> 3
    int Q22 = Q((P21 & 0b0011) | ((Q21 << 2) & 0b1100));
    //1101 -> B

    //printf("1: %x\n", P12);
    //printf("2: %x\n", Q12);
    //printf("3: %x\n", P22);
    //printf("4: %x\n", Q22);


    int out_data = (P12<<12) | (Q12 << 8) | (P22 <<4) | Q22;
    printf("K: %x\n", out_data);
    return out_data;
} 



int keygen(long int seed){
    int cat_node0 = ((seed >> 48) & 0xf000) | ((seed >> 36) & 0x0f00) | ((seed >> 24) & 0x00f0) | ((seed >> 12) & 0x000f);
    int cat_node1 = ((seed >> 44) & 0xf000) | ((seed >> 32) & 0x0f00) | ((seed >> 20) & 0x00f0) | ((seed >> 8)  & 0x000f);
    int cat_node2 = ((seed >> 40) & 0xf000) | ((seed >> 28) & 0x0f00) | ((seed >> 16) & 0x00f0) | ((seed >> 4)  & 0x000f);
    int cat_node3 = ((seed >> 36) & 0xf000) | ((seed >> 24) & 0x0f00) | ((seed >> 12) & 0x00f0) | ((seed)       & 0x000f);
    //printf("1: %x\n", cat_node0);
    //printf("2: %x\n", cat_node1);
    //printf("3: %x\n", cat_node2);
    //printf("4: %x\n", cat_node3);
    
    int k1 = f_function(0x0123); 
    int k2 = f_function(0x4567); 
    int k3 = f_function(0x89ab); 
    int k4 = f_function(0xcdef);
    int k5 = k1 ^ k2 ^ k3 ^ k4;
    printf("K5: %x\n", k5);
    return 0;
}

int xnor(int x, int y) {
    return ~(x^y);
}

int xor(int x, int y) {
    return x^y;
}

void baseEncrypt(long int *d1, long int *d2, long int *d3, long int *d4, int step_key){
    int Rox1 = xnor(*d1, step_key);
    int Rox4 = xnor(*d4, step_key);

    int Eflx = f_function(Rox1);
    int Efrx = f_function(Rox4);

    int Rox2 = xor(Eflx, *d3);
    int Rox3 = xor(Efrx, *d2);

    *d1 = Rox1;
    *d2 = Rox2;
    *d3 = Rox3;
    *d4 = Rox4;

    printf("Rox1 = %x\n", Rox1);
    printf("Rox2 = %x\n", Rox2);
    printf("Rox3 = %x\n", Rox3);
    printf("Rox4 = %x\n", Rox4);
}

long int encrypt(long int data, int k1, int k2, int k3, int k4, int k5) {
    long int d1 = (data & 0x0ffff);
    long int d2 = ((data >> 16) & 0x0ffff);
    long int d3 = ((data >> 32) & 0x0ffff);
    long int d4 = ((data >> 48) & 0x0ffff);
 
    baseEncrypt(&d1, &d2, &d3, &d4, k1);
    baseEncrypt(&d2, &d1, &d4, &d3, k2);
    baseEncrypt(&d1, &d2, &d3, &d4, k3);
    baseEncrypt(&d2, &d1, &d4, &d3, k4);
    baseEncrypt(&d1, &d2, &d3, &d4, k5);    
    
    long int output = (d4 << 48) | (d3 << 32) | (d2 << 16) | (d1);
    return output;
}

int main(){
    long int ini_seed = 0x0123456789abcdef;
    //keygen(ini_seed);
    long int output = encrypt(ini_seed, 0x1234, 0x1234, 0x1234, 0x1234, 0x1234);
    printf("The initial message is: %lx\n", ini_seed);
    printf("The encrypted message is: %lx\n", output);
    ini_seed = output;
    output = encrypt(output, 0x1234, 0x1234, 0x1234, 0x1234, 0x1234);
    printf("The initial message is: %lx\n", ini_seed);
    printf("The encrypted message is: %lx\n", output);


    return 0;
}


//ffffffaafffffaaafffffffaffffffaa

//input
//0123456789abcdef
//output
//048c
//159d
//26ae
//37bf
