----------------------------------------------------------------------------------
-- Engineer: Bilal Kabas
-- 
-- Create Date: 14.04.2020
-- Project Name: Security System
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity main_tb is
end main_tb;

architecture Behavioral of main_tb is
    component main
        Port(   clk         : in std_logic;
                BCD_input   : in std_logic_vector(11 downto 0);           -- Password BCD input
                reset       : in std_logic;                               -- Reset button
                PS          : in std_logic;                               -- Password setup button
                AR          : in std_logic;                               -- Arm mode button
                DO          : in std_logic;                               -- Door open mode button
                CP          : in std_logic;                               -- Password entry button
                SL          : inout std_logic;                            -- Status LED
                DL          : out std_logic;                              -- Door open LED
                PL1         : inout std_logic;                            -- Attempt LED 1
                PL2         : inout std_logic;                            -- Attempt LED 2
                PL3         : inout std_logic;                            -- Attempt LED 3
                ALM         : inout std_logic := '0';                     -- Alarm              
                PASS        : out std_logic_vector(11 downto 0) );        -- Password output
    end component;

    -- Inputs
    signal clk : std_logic;
    signal reset : std_logic;
    signal BCD_input : std_logic_vector(11 downto 0);
    signal PS : std_logic;
    signal AR : std_logic;
    signal DO : std_logic;
    signal CP : std_logic;
    
    -- Outputs
    signal SL : std_logic;
    signal DL : std_logic;
    signal PL1 : std_logic;    
    signal PL2 : std_logic;
    signal PL3 : std_logic;    
    signal ALM : std_logic;  
    signal PASS : std_logic_vector(11 downto 0);

    -- Period
    constant clk_period : time := 10ns;
    
    -- File Handling
    file input_buf : text;
    file output_buf : text;

begin

    UUT : main port map (clk,BCD_input,reset,PS,AR,DO,CP,SL,DL,PL1,PL2,PL3,ALM,PASS);

    clk_process:process
    begin
        clk<='0';
        wait for clk_period/2;
        clk<='1';
        wait for clk_period/2;
    end process;

    stimulus : process
        variable read_col_from_input_buf : line;
        variable col_1 : std_logic_vector(11 downto 0);
        variable col_2, col_3, col_4, col_5,col_6: std_logic;
        variable val_SPACE : character;
        variable write_col_to_output_buf : line;  
    begin
        -- File handling
        file_open(input_buf, "replace_with_your_directory\simulation.txt",  read_mode);
        file_open(output_buf, "replace_with_your_directory\output.txt",  write_mode);
        
        while not endfile(input_buf) loop
          -- Read operation 
          readline(input_buf, read_col_from_input_buf);
          read(read_col_from_input_buf, col_1);
          read(read_col_from_input_buf, val_SPACE);
          read(read_col_from_input_buf, col_2);
          read(read_col_from_input_buf, val_SPACE);
          read(read_col_from_input_buf, col_3);
          read(read_col_from_input_buf, val_SPACE);
          read(read_col_from_input_buf, col_4);
          read(read_col_from_input_buf, val_SPACE);
          read(read_col_from_input_buf, col_5);
          read(read_col_from_input_buf, val_SPACE);
          read(read_col_from_input_buf, col_6);

          -- Pass the read values to signals
          BCD_input <= col_1;
          PS        <= col_2;
          AR        <= col_3;
          DO        <= col_4;
          CP        <= col_5;
          reset     <= col_6;
          
          wait for clk_period;

          -- Writing operation
          write(write_col_to_output_buf, PASS);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, SL);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, DL);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, PL1);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, PL2);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, PL3);
          write(write_col_to_output_buf, string'(" "));
          write(write_col_to_output_buf, ALM);
          writeline(output_buf, write_col_to_output_buf);
          
        end loop;
        
        file_close(input_buf);             
        
        wait;
    end process;

end Behavioral;
