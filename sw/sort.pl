#!/usr/bin/perl -w
use lib "/usr/local/netfpga/lib/Perl5";
use strict;

my $ALU_MEM_DATA_LOW      = 0x2000300;
my $ALU_MEM_DATA_HIGH     = 0x2000304;
my $ALU_MEM_ADDR_EN       = 0x2000308;
my $ALU_ISTR_DATA         = 0x200030c;
my $ALU_ISTR_ADDR_EN      = 0x2000310;
my $ALU_PC_EN             = 0x2000314;
my $ALU_MEM_RD_DATA_LOW   = 0x2000318;
my $ALU_MEM_RD_DATA_HIGH  = 0x200031c;
my $ALU_ISTR_RD_DATA      = 0x2000320;
my $ALU_COUNT_IN          = 0x2000324;

my @instr_array=(
0x0100006F,
0x0640006F,
0x0B80006F,
0x10C0006F,
0x00400213,
0x00002283,
0x00030313,
0xFFF28393,
0x14730863,
0x40638433,
0x00000493,
0x02848A63,
0x00249513,
0x00450533,
0x00052583,
0x00450613,
0x00062683,
0x00B6C663,
0x00148493,
0xFE1FF06F,
0x00B62023,
0x00D52023,
0x00148493,
0xFD1FF06F,
0x00130313,
0xFBDFF06F,
0x01C00213,
0x00002283,
0x00030313,
0xFFF28393,
0x0E730C63,
0x40638433,
0x00000493,
0x02848A63,
0x00249513,
0x00450533,
0x00052583,
0x00450613,
0x00062683,
0x00B6C663,
0x00148493,
0xFE1FF06F,
0x00B62023,
0x00D52023,
0x00148493,
0xFD1FF06F,
0x00130313,
0xFBDFF06F,
0x03400213,
0x00002283,
0x00030313,
0xFFF28393,
0x0A730063,
0x40638433,
0x00000493,
0x02848A63,
0x00249513,
0x00450533,
0x00052583,
0x00450613,
0x00062683,
0x00B6C663,
0x00148493,
0xFE1FF06F,
0x00B62023,
0x00D52023,
0x00148493,
0xFD1FF06F,
0x00130313,
0xFBDFF06F,
0x04C00213,
0x00002283,
0x00030313,
0xFFF28393,
0x04730463,
0x40638433,
0x00000493,
0x02848A63,
0x00249513,
0x00450533,
0x00052583,
0x00450613,
0x00062683,
0x00B6C663,
0x00148493,
0xFE1FF06F,
0x00B62023,
0x00D52023,
0x00148493,
0xFD1FF06F,
0x00130313,
0xFBDFF06F,
0x0000006F);

my @data_mem=(
0x6,
0x3,
0x2,
0x9,
0x7,
0x5,
0x2,
0x1,
0x0,
0xb,
0x4,
0x9,
0xc,
0xb,
0xc,
0xd,
0xa,
0x5,
0x3,
0xa,
0xc,
0x4,
0x8,
0x0,
0x9);

my @loop = (0..63);
my @data_loop = (0..4);
my @rd_loop = (0..9);
sub data_write {
   print "### WRITE DATA ###\n";
   for my $i (@data_loop){
       regwrite( $ALU_MEM_ADDR_EN, 0x0100+$i); # assert write en for memory
       regwrite( $ALU_MEM_DATA_LOW, $data_mem[$i*2]); # write to memory
       regwrite( $ALU_MEM_DATA_HIGH, $data_mem[$i*2+1]); # write to memory
       regwrite( $ALU_MEM_ADDR_EN, 0x0000+$i); # dassert write en eq
   }
   
   print "###### VALUES WRITTEN ARE ####";
   for my $i (@data_loop){
       regwrite( $ALU_MEM_ADDR_EN, 0x0000+$i); # write en for memory
       print "READ ADDRESS",$i+5," :    ", regread( $ALU_MEM_RD_DATA_LOW ), "\n";
       print "READ ADDRESS",$i+5," :    ", regread( $ALU_MEM_RD_DATA_HIGH ), "\n";
   }
}

sub read_data {
   print "###### VALUES WRITTEN ARE ####";
   for my $i (@rd_loop){
       regwrite( $ALU_MEM_ADDR_EN, 0x0000+$i); # write en for memory
       print "READ ADDRESS LOW ",$i," :    ", regread( $ALU_MEM_RD_DATA_LOW ), " ";
       print "HIGH",$i," :    ", regread( $ALU_MEM_RD_DATA_HIGH ), "\n";
   }
}
   
sub istr_write {
   print "### WRITE INSTR ###\n";
   for my $i (@loop){
       regwrite( $ALU_ISTR_DATA, $instr_array[$i]); # write to memory
       regwrite( $ALU_ISTR_ADDR_EN, 0x0200+$i); # write at memory address 0
       regwrite( $ALU_ISTR_ADDR_EN, 0x0000+$i); # en low
   }
   print "Written instructions\n";
   
   #print "Enable PC\n";
   #regwrite( $ALU_PC_EN, 0x001); # Enable the PC
   
   #print "DISABLE PC\n";
   #regwrite( $ALU_PC_EN, 0x000); # DISABLE the PC
   print "###### VALUES WRITTEN ARE ####";
   for my $i (@data_loop){
       regwrite( $ALU_MEM_ADDR_EN, 0x0000+$i); # write en for memory
       print "READ ADDRESS LOW ",$i," :    ", regread( $ALU_MEM_RD_DATA_LOW ), " ";
       print "HIGH",$i," :    ", regread( $ALU_MEM_RD_DATA_HIGH ), "\n";
   }
}

sub PC_EN {
   print "Enable PC\n";
   regwrite( $ALU_PC_EN, 0x00000001); # Enable the PC
}
sub PC_DEN {
   print "DISABLE PC\n";
   regwrite( $ALU_PC_EN, 0x00000000); # Enable the PC
}

sub reset_dev {
   print "RESET PC\n";
   regwrite( $ALU_PC_EN, 0x010); # Enable the PC
   sleep(1);
   regwrite( $ALU_PC_EN, 0x000); # Enable the PC
}


sub regwrite {
   my( $addr, $value ) = @_;
   my $cmd = sprintf( "regwrite $addr 0x%08x", $value );
   my $result = `$cmd`;
   # print "Ran command '$cmd' and got result '$result'\n";
}

sub regread {
   my( $addr ) = @_;
   my $cmd = sprintf( "regread $addr" );
   my @out = `$cmd`;
   my $result = $out[0];
   if ( $result =~ m/Reg (0x[0-9a-f]+) \((\d+)\):\s+(0x[0-9a-f]+) \((\d+)\)/ ) {
      $result = $3;
   }
   return $result;
}
sub usage {
   print "Usage: idsreg <cmd> <cmd options>\n";
   print "  Commands:\n";
   print "    alu             WRITE INSTR\n";
   print "    data            WRITE DATA\n";
   print "    pcen            EN PC\n";
   print "    pcd             DISABLE PC\n";
   print "    rd              read data\n";
   print "    reset           reset ALU and FIFO\n";
}

print "READ Counters :    ", regread( $ALU_COUNT_IN ), " \n";

my $numargs = $#ARGV + 1;
if( $numargs < 1 ) {
   usage();
   exit(1);
}
my $cmd = $ARGV[0];
if ($cmd eq "data") {
   data_write();
}
elsif ($cmd eq "alu") {
   istr_write();
} elsif ($cmd eq "reset") {
   reset_dev();
} elsif ($cmd eq "pcen") {
   PC_EN();
} elsif ($cmd eq "pcd") {
   PC_DEN();
} elsif ($cmd eq "rd") {
   read_data();
} else {
   print "Unrecognized command $cmd\n";
   usage();
   exit(1)
}

