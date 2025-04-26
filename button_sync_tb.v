`timescale 1ns/1ps
module button_sync_tb;

	reg clk;
	reg rst;
	reg btn_in;
	wire btn_sync;
	
	button_sync uut(
		.clk(clk),
		.rst(rst),
		.btn_in(btn_in),
		.btn_sync(btn_sync)
	);
	//每5ns反轉一次,產生10ns週期時脈(100MHz)
	always #5 clk = ~clk;
	
	integer f;
	initial begin
		$dumpfile("button_sync.vcd");
		$dumpvars(0,button_sync_tb);
		
		f=$fopen("monitor_log.txt");
		if(!f) begin
			$display("Failed to open monitor_log.txt");
			$finish;
		end
		
		//初始狀態
		clk = 0;
		rst = 1;
		btn_in = 0;
		#20;
		rst = 0;
		
		//模擬按鈕抖動(快速亂跳)
		btn_in =1; #7;
		btn_in =0; #4;
		btn_in =1; #6;
		btn_in =0; #5;	
	
	   //正常按一下按鈕
      #10;
		btn_in = 1;#20;
		btn_in = 0;
		
		//再按一下按鈕
		#30;
		btn_in = 1;#20;
		btn_in =0;
		
		//寫入log
		$fwrite(f,"btn_in=%b btn_sync=%b @ %0t ns\n", btn_in, btn_sync, $time);
		
		#100;
		$fclose(f);
		$display("Simulation Finished");
		$finish;
	end
endmodule