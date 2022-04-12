lw x1, 152(x0)
lw x2, 128(x0)       
and x3, x2, x1       
srli x4, x2, 0x10    
and x4, x4, x1       
srli x5, x2, 0x10
srli x5, x5, 0x10    
and x5, x5, x1       
srli x6, x2, 0x10
srli x6, x6, 0x10    
srli x6, x6, 0x10    
and x6, x6, x1       
addi x28, x28, 5     
addi x27, x0, 16
loop:
lw x7, 132(x27)      
xor x26, x3, x7       
xori x26, x26, -1      
and x26, x26, x1

srli x8, x6, 0xc
slli x8, x8, 0x2     
lw x9, 0(x8)

srli x8, x6, 0x8     
andi x8 ,x8, 0x000f
slli x8, x8, 0x2     
lw x10, 64(x8)

srli x8, x6, 0x4     
andi x8 ,x8, 0x000f
slli x8, x8, 0x2     
lw x11, 0(x8)

andi x31, x6, 0x000f
slli x31, x31, 0x2 
lw x12, 64(x31)

andi x13, x9, 0xc 
srli x22, x10, 0x2   
or x13, x13, x22
slli x13, x13, 0x2     
lw x13, 64(x13)

slli x9, x9, 0x2     
srli x23, x11, 0x2
or x14, x9, x23
andi x14, x14, 0x0f
slli x14, x14, 0x2 
lw x14, 0(x14)

slli x10, x10, 0x2
srli x15, x12, 0x2   
or x15, x15, x10     
andi x15, x15, 0x0f
slli x15, x15, 0x2  
lw x15, 64(x15)

andi x12, x12, 0x3
slli x11, x11, 0x2   
andi x11, x11, 0xc
or x11, x11, x12     
slli x11, x11, 0x2
lw x16, 0(x11)

andi x17, x13, 0xc
srli x24, x14, 2     
or x17, x17, x24
slli x17, x17, 0x2
lw x17, 0(x17)

slli x13, x13, 0x2   
srli x25, x15, 0x2   
or x18, x13, x25     
andi x18, x18, 0x0f
slli x18, x18, 0x2  
lw x18, 64(x18)

slli x14, x14, 0x2   
srli x19, x16, 0x2   
or x19, x19, x14     
andi x19, x19, 0x0f
slli x19, x19, 0x2  
lw x19, 0(x19)

andi x16, x16, 0x3
slli x15, x15, 0x2
andi x15, x15, 0xc
or x16, x15, x16     
slli x16, x16, 0x2
lw x16, 64(x16)

slli x17, x17, 0xc   
slli x18, x18, 0x8   
slli x19, x19, 0x4   
or x17, x17, x18     
or x18, x19, x16     
or x20, x17, x18     
xor x20, x5, x20     
and x20, x20, x1     
xor x6, x6, x7       
xori x6, x6, -1      
and x6, x6, x1






srli x8, x3, 0xc
slli x8, x8, 0x2     
lw x9, 0(x8)

srli x8, x3, 0x8    
andi x8 ,x8, 0x000f
slli x8, x8, 0x2     
lw x10, 64(x8)

srli x8, x3, 0x4     
andi x8 ,x8, 0x000f
slli x8, x8, 0x2     
lw x11, 0(x8)

andi x30, x3, 0x000f
slli x30, x30, 0x2 
lw x12, 64(x30)

andi x13, x9, 0xc 
srli x22, x10, 0x2   
or x13, x13, x22
slli x13, x13, 0x2     
lw x13, 64(x13)

slli x9, x9, 0x2     
srli x23, x11, 0x2   
or x14, x9, x23      
andi x14, x14, 0x0f
slli x14, x14, 0x2  
lw x14, 0(x14)

slli x10, x10, 0x2   
srli x15, x12, 0x2   
or x15, x15, x10     
andi x15, x15, 0x0f
slli x15, x15, 0x2  
lw x15, 64(x15)

andi x12, x12, 0x3
slli x11, x11, 0x2       
andi x11, x11, 0xc
or x11, x11, x12 
slli x11, x11, 0x2
lw x16, 0(x11)

andi x17, x13, 0xc
srli x24, x14, 0x2     
or x17, x17, x24
slli x17, x17, 0x2
lw x17, 0(x17)

slli x13, x13, 0x2   
srli x25, x15, 0x2   
or x18, x13, x25     
andi x18, x18, 0x0f
slli x18, x18, 0x2  
lw x18, 64(x18)

slli x14, x14, 0x2   
srli x19, x16, 0x2   
or x19, x19, x14     
andi x19, x19, 0x0f
slli x19, x19, 0x2  
lw x19, 0(x19)

andi x16, x16, 0x3
slli x15, x15, 0x2   
andi x15, x15, 0xc
or x16, x15, x16     
slli x16, x16, 0x2
lw x16, 64(x16)

slli x17, x17, 0xc    
slli x18, x18, 0x8    
slli x19, x19, 0x4    
or x17, x17, x18     
or x18, x19, x16     
or x21, x17, x18     
xor x21, x4, x21     
and x21, x21, x1     
addi x4, x26, 0      
addi x3, x20, 0     
addi x5, x6, 0      
addi x6, x21, 0     
addi x29, x29, 1
addi x27, x27, -4
bne x29, x28, loop
slli x5, x5, 0x10
slli x5, x5, 0x10
slli x5, x5, 0x10   
slli x6, x6, 0x10
slli x6, x6, 0x10    
slli x3, x3, 0x10    
or x6, x5, x6        
or x4, x3, x4        
or x7, x6, x4
sw x7, 152(x0)     
EXIT:
