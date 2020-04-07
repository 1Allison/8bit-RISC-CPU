
/*************************  * TEST BENCH FOR MEMORY *  *************************/ 
 
`timescale 1 ns / 1 ns 
 
module mem_test ; 
 
  reg        read  ;
   reg        write ;
   reg  [4:0] addr  ; 
   reg [7:0] dreg;
    wire  [7:0] data=(!read)?dreg:8'hZ;
     integer    i     ; 
 
// Instantiate memory submodule 
 
  mem m1 ( .data(data), .addr(addr), .read(read), .write(write) ) ; 
 
// Monitor signals 
 
  initial
     begin
       $timeformat ( -9, 1, " ns", 9 ) ;
       $display("  TIME    ADDR  WR RD   DATA  ");
       $display("--------- ----- -- -- --------");
       $monitor ( "%t %b %b  %b  %b", $time, addr, write, read, data ) ;
       $dumpvars(2,mem_test);
     end 
 
// Define write task 
 
  task write_val;
   input [4:0] addr ;
   input [7:0] data ;
     begin
       mem_test.addr = addr ;
       mem_test.dreg= data ;
       #1 write = 1 ;
       #1 write = 0 ;
     end
   endtask 
 // Define read task 
 
  task read_val ;
   input [4:0] addr ;
   input [7:0] data ;
     begin
       mem_test.addr = addr ;
       mem_test.read = 1 ;
       #1 if ( mem_test.data !== data )
            begin
              $display ( "At time %t and addr %b,  data is %b and should be %b",                          $time, addr, mem_test.data, data ) ;
              $display ( "TEST FAILED" ) ; 
             $finish ; 
           end
       #1 read = 0 ;
     end
   endtask 
 
 
// Apply stimulus 
 
  initial
     begin       // INITIALIZE CONTROL SIGNALS
       write = 0 ; read = 0 ; //请注意 memory 的工作方式,必须先给存储器写入数据,然后才读出.
       // WRITE DATA = ADDR 
      for ( i=0; i<=31; i=i+1 )
         write_val ( i, i ) ;
       // READ DATA = ADDR
       for ( i=0; i<=31; i=i+1 )
         read_val ( i, i ) ; 
      $display ( "TEST PASSED" ) ; 
      $finish ;
     end 
 
endmodule 