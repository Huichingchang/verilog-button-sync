`timescale 1ns/1ps
module button_sync(
	input wire clk, //系統時脈
	input wire rst, //非同步Reset
	input wire btn_in, //來自外部的按鈕訊號(非同步)
	output reg btn_sync //同步後的按鈕訊號
	
);

	reg sync_ff1, sync_ff2;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			sync_ff1 <= 0;
			sync_ff2 <= 0;
			btn_sync <= 0;
		end
		else begin
			sync_ff1 <= btn_in; //第一級暫存
			sync_ff2 <= sync_ff1; //第二級暫存
			btn_sync<= sync_ff2; //最後輸出
		end
	end
endmodule