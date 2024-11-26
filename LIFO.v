module LIFO ( 
input rst, // Reset signal to reset the stack 
input enable, // Enable signal to trigger stack operations 
input push, // Push signal to add data to the stack 
input pop, // Pop signal to remove data from the stack 
input [3:0] data_in, // 4-bit data input to be pushed into the stack 
output reg [3:0] data_out, // 4-bit data output from the stack when popped 
output reg empty, // Indicates if the stack is empty 
output reg full, // Indicates if the stack is full 
output reg invalid // Indicates if an invalid operation (push/pop) occurs 
); 
parameter DEPTH = 8; // Stack depth (8 locations) 
reg [3:0] stack [0:DEPTH-1]; // Stack memory (8 locations, each 4 bits) 
reg [2:0] top; // 3-bit stack pointer (can address up to 8 locations) 
 
// Initialize the stack to default values 
initial begin 
top = 3'b000; // Stack pointer starts at 0 
empty = 1; // Initially, the stack is empty 
full = 0; // Initially, the stack is not full 
invalid = 0; // No invalid operations initially 
end 
// Stack operations on each clock edge, triggered by enable or reset 
always @(posedge enable or posedge rst) begin 
if (rst) begin // If reset signal is active 
top <= 3'b000; // Reset the stack pointer to 0 
empty <= 1; // The stack is now empty 
full <= 0; // The stack is not full 
invalid <= 0; // No invalid operations 
data_out <= 4'b0000; // Clear output data 
end else if (enable) begin // If enable is active, perform stack operations 
invalid <= 0; // Reset invalid flag for valid operations 
// Push operation 
if (push && !full) begin // If pushing and stack is not full 
stack[top] <= data_in; // Add input data to the stack at the current top 
top <= top + 1; // Move the stack pointer up 
empty <= 0; // The stack is no longer empty 
full <= (top == DEPTH - 2); // Stack becomes full when top is one below DEPTH 
end else if (push && full) begin // If pushing but the stack is full 
invalid <= 1; // Invalid operation (stack is full) 
end 
 
 
// Pop operation 
if (pop && !empty) begin // If popping and stack is not empty 
top <= top - 1; // Move the stack pointer down 
data_out <= stack[top - 1]; // Output the data from the current top 
full <= 0; // Stack is no longer full 
empty <= (top == 1); // Stack becomes empty if top is 1 
end else if (pop && empty) begin // If popping but the stack is empty 
invalid <= 1; // Invalid operation (stack is empty) 
end 
end 
end 
 
endmodule
