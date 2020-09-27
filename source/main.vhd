----------------------------------------------------------------------------------
-- Engineer: Bilal Kabas
-- 
-- Create Date: 14.04.2020 19:10:02
-- Project Name: Security System
----------------------------------------------------------------------------------
-- Important Notes:
-- Even if the given password is greater than 999, system accepts it as an attempt in the door open mode.
-- For the demonstration purposes, blinking of LEDs represented by X. Actual code is SL <= clk_1hz.
-- The global clock and 1 Hz clock are equal to each other for simulation purposes.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
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
end main;

architecture Behavioral of main is
    signal password   : std_logic_vector(11 downto 0) := X"000";
    signal clk_1hz    : std_logic := '0';
    signal timer      : integer range 0 to 29 := 0;
    signal TU         : std_logic := '0';               -- Time is up flag
    signal PV         : std_logic := '1';               -- Password valid flag
    signal PM         : std_logic := '1';               -- Password match flag
    signal attempt    : integer range 0 to 3 := 0;
    -- States
    type state_type is (idle, pass_set, armed, door_open);
    signal state    : state_type;
begin
    clk_1hz <= clk;

    OFL : process(state,clk,attempt,ALM,TU)
    begin
        case state is
            when idle =>
                SL  <= 'X';
                DL  <= '0';
                PL1 <= '0';
                PL2 <= '0';
                PL3 <= '0';
                ALM <= '0';
            
            when pass_set =>
                SL  <= '0';
                DL  <= '0';
                PL1 <= '0';
                PL2 <= '0';
                PL3 <= '0';
                ALM <= '0';
            
            when armed =>
                SL  <= '1';
                DL  <= '0';
                PL1 <= '0';
                PL2 <= '0';
                PL3 <= '0';
                ALM <= '0';
            
            when door_open =>
                SL  <= '1';
                DL  <= '1';
                -- LED outputs
                if attempt = 1 then
                    PL1 <= '1';
                elsif attempt = 2 then
                    PL2 <= '1';
                elsif ALM = '1' or attempt = 3 then
                    PL1 <= 'X';
                    PL2 <= 'X';
                    PL3 <= 'X';
                end if;
                -- Alarm
                if attempt = 3 or TU = '1' then
                    ALM <= '1';
                end if;
            
            end case;
    end process;

    NSL : process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when idle =>
                    if (PS and not AR) = '1' then
                        state <= pass_set;
                    elsif AR = '1' then
                        state <= armed;
                    else state <= idle;
                    end if;
                
                when pass_set =>
                    if PS = '1' and PV = '1' then
                        state <= idle;
                        password <= BCD_input;
                    else state <= pass_set;
                    end if;
                
                when armed =>
                    if DO = '1' then
                        state <= door_open;
                    else state <= armed;
                    end if;
                
                when door_open =>
                    -- Timer and TU (Time is up) flag
                    if timer < 29 and ALM = '0' then
                        timer <= timer + 1;
                    else timer <= 0;
                    end if;
                    if timer = 29 then
                        TU <= '1';
                    end if;
                    -- Attempt Counter
                    if (CP and not ALM) = '1' then
                        if PM = '1' then
                            state   <= idle;
                            attempt <= 0;
                            timer   <= 0;
                            TU <= '0';
                        elsif attempt < 3 then
                            attempt <= attempt + 1;
                            state   <= door_open;
                        end if;
                    end if;
                    -- Reset
                    if (reset and ALM) = '1' then
                        state    <= idle;
                        attempt  <= 0;
                        timer    <= 0;
                        TU <= '0'; 
                        password <= X"000";
                    end if;
            
            end case;
        end if;
    end process;
    
    Password_Validator : process(BCD_input)
    begin
        -- Check Validity
        if (BCD_input(11 downto 8) < "1010" and BCD_input(7 downto 4) < "1010" and BCD_input(3 downto 0) < "1010") then
            PV <= '1';
        else PV <= '0';
        end if;
        -- Check Macth
        if BCD_input = password then
            PM <= '1';
        else PM <= '0';
        end if;
    end process;
    
    PASS <= password;
end Behavioral;
