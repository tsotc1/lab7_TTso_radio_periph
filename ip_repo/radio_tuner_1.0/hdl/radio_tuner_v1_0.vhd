library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity radio_tuner_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
		--output master axi stream for FIR_2 output
        m_axis_tvalid   : out   std_logic;
        m_axis_tready   : in    std_logic;
        m_axis_tdata    : out   std_logic_vector(31 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end radio_tuner_v1_0;

architecture arch_imp of radio_tuner_v1_0 is

	-- component declaration
	component radio_tuner_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        DDS_PINC    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        LoDDS_PINC  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        DDS_rst     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component radio_tuner_v1_0_S00_AXI;
	
    COMPONENT DDS
        PORT (
            aclk : IN STD_LOGIC;
            aresetn : IN STD_LOGIC;
            s_axis_phase_tvalid : IN STD_LOGIC;
            s_axis_phase_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_data_tvalid : OUT STD_LOGIC;
            m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            m_axis_phase_tvalid : OUT STD_LOGIC;
            m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
       
    COMPONENT FIR_1
        PORT (
            aclk : IN STD_LOGIC;
            s_axis_data_tvalid : IN STD_LOGIC;
            s_axis_data_tready : OUT STD_LOGIC;
            s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_data_tvalid : OUT STD_LOGIC;
            m_axis_data_tready : IN STD_LOGIC;
            m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT FIR_2 
        PORT (
            aclk : IN STD_LOGIC;
            s_axis_data_tvalid : IN STD_LOGIC;
            s_axis_data_tready : OUT STD_LOGIC;
            s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            m_axis_data_tvalid : OUT STD_LOGIC;
            m_axis_data_tready : IN STD_LOGIC;
            m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
        );
    END COMPONENT;
    
    COMPONENT Lo_DDS
      PORT (
        aclk : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_phase_tvalid : IN STD_LOGIC;
        s_axis_phase_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_data_tvalid : OUT STD_LOGIC;
        m_axis_data_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_phase_tvalid : OUT STD_LOGIC;
        m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT cMult_0
      PORT (
        aclk : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_b_tvalid : IN STD_LOGIC;
        s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_dout_tvalid : OUT STD_LOGIC;
        m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(79 DOWNTO 0)
      );
    END COMPONENT;
	
	
    --wiring for PS7/Block Diagram to DDS IP
    signal w_DDS_phaseIn : std_logic_vector(31 downto 0);
    signal w_AXIS_DDS_tdata_SinOut : std_logic_vector(15 downto 0);
    signal w_AXIS_DDS_tvalid_SinOut : std_logic;
    signal w_AXIS_DDS_tdata_phaseOut : std_logic_vector(31 downto 0);
    signal w_AXIS_DDS_tvalid_phaseOut : std_logic;
    signal w_DDS_rstn : std_logic;
    signal w_DDS_rst : std_logic_vector(31 downto 0);    --only LSB is used for DDS reset
    
    --wiring for FIR filters
    signal w_DDS_out_atten  : std_logic_vector(15 downto 0);    --attenuated DDS output
    signal w_FIR1_tvalid    : std_logic;
    signal w_FIR1_tready    : std_logic;
    signal w_FIR1_tdata     : std_logic_vector(47 downto 0);  
    signal w_FIR2_tvalid    : std_logic;
    signal w_FIR2_tready    : std_logic;
    signal w_FIR2_tdata     : std_logic_vector(47 downto 0);
    
    --wiring for LO DDS
    signal w_LO_DDS_phaseIn     : std_logic_vector(31 downto 0);
    signal w_AXIS_LO_DDS_tdata  : std_logic_vector(31 downto 0);
    signal w_AXIS_LO_DDS_tvalid : std_logic;
    
    --wiring for complex multiplier
    signal w_cmplxSig           : std_logic_vector(31 downto 0);
    signal w_cMult_tvalid       : std_logic;
    signal w_cMult_tdata        : std_logic_vector(79 downto 0); 
    signal w_DDS_mix_tdata      : std_logic_vector(31 downto 0);
    
    --wiring for complex signals into filters
    signal w_FIR1_tdata_sliced  : std_logic_vector(31 downto 0);
    signal w_FIR2_tdata_sliced  : std_logic_vector(31 downto 0);
    
    --alias for clock to retain copy and paste of Lab 6 VHDL
    signal clk  : std_logic;

	
begin

-- Instantiation of Axi Bus Interface S00_AXI
radio_tuner_v1_0_S00_AXI_inst : radio_tuner_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        DDS_PINC    => w_DDS_phaseIn,
        LoDDS_PINC  => w_LO_DDS_phaseIn,
        DDS_rst     => w_DDS_rst,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-------------------- Add user logic here --------------------------------------
	--mostly a copy and paste of Lab 6 VHDL with a few modifications for IP packaging
	clk <= s00_axi_aclk;
	w_DDS_rstn <= not(w_DDS_rst(0)) and s00_axi_aresetn;
	
    DDS_i : DDS
    PORT MAP (
        aclk => clk,
        aresetn => w_DDS_rstn,
        s_axis_phase_tvalid => '1',
        s_axis_phase_tdata =>  w_DDS_phaseIn(31 downto 0),
        m_axis_data_tvalid => w_AXIS_DDS_tvalid_SinOut,
        m_axis_data_tdata => w_AXIS_DDS_tdata_SinOut(15 downto 0),
        m_axis_phase_tvalid => w_AXIS_DDS_tvalid_phaseOut,            
        m_axis_phase_tdata => w_AXIS_DDS_tdata_phaseOut(31 downto 0)
    ); 
    
    Lo_DDS_i : Lo_DDS
    PORT MAP (
        aclk => clk,
        aresetn => w_DDS_rstn,
        s_axis_phase_tvalid => '1',
        s_axis_phase_tdata => w_LO_DDS_phaseIn,
        m_axis_data_tvalid => w_AXIS_LO_DDS_tvalid,
        m_axis_data_tdata => w_AXIS_LO_DDS_tdata,
        m_axis_phase_tvalid => open,
        m_axis_phase_tdata => open
    ); 
    
    --input to complex multiply is ordered as imag(31 downto 16) & real(15 downto 0)
    --input signal is real only so set imag part to zero
    w_cmplxSig(31 downto 0) <= x"0000" & w_AXIS_DDS_tdata_SinOut(15 downto 0);
    
    --cMult_0 s_axis_a/b_tdata structure: imag(31 downto 16) & real(15 downto 0), both are fix16_0
    --cMult_0 m_axis_dout_tdata structure: imag(72 downto 40) & real(32 downto 0), both are fix33_0
    cMult_0_i : cMult_0
      PORT MAP (
        aclk => clk,
        aresetn => w_DDS_rstn,
        s_axis_a_tvalid => w_AXIS_LO_DDS_tvalid,
        s_axis_a_tdata => w_AXIS_LO_DDS_tdata,
        s_axis_b_tvalid => w_AXIS_DDS_tvalid_SinOut,
        s_axis_b_tdata => w_cmplxSig,
        m_axis_dout_tvalid => w_cMult_tvalid,
        m_axis_dout_tdata => w_cMult_tdata
      );
    
    --The Signal DDS has an output format of Q16.14 and the LO/Mixer DDS is formatted to Q16.15
    --The product of these two signals will have an output format of Q32.29
    --To retain the original scaling of the Signal DDS we need an output format of Q16.14 thus we 
    --need to slice bits (30 downto 15) of the real part of the complex multiply
    --and bits (70 downto 55) of the imaginary part of the complex multiply
    w_DDS_mix_tdata <= w_cMult_tdata(70 downto 55) & w_cMult_tdata(30 downto 15);
    
    FIR_1_i : FIR_1
    PORT MAP (
        aclk => clk,
        s_axis_data_tvalid => w_cMult_tvalid,
        s_axis_data_tready => open,
        s_axis_data_tdata => w_DDS_mix_tdata(31 downto 0),
        m_axis_data_tvalid => w_FIR1_tvalid,
        m_axis_data_tready => w_FIR1_tready,
        m_axis_data_tdata => w_FIR1_tdata(47 downto 0)
    );
    
    --only retain the lower 16 bits of each of the imag and real signals out of FIR_1
    w_FIR1_tdata_sliced <= w_FIR1_tdata(39 downto 24) & w_FIR1_tdata(15 downto 0);
    
    FIR_2_i : FIR_2
    PORT MAP (
        aclk => clk,
        s_axis_data_tvalid => w_FIR1_tvalid,
        s_axis_data_tready => w_FIR1_tready,
        s_axis_data_tdata => w_FIR1_tdata_sliced(31 downto 0),
        m_axis_data_tvalid => w_FIR2_tvalid,
        m_axis_data_tready => w_FIR2_tready,
        m_axis_data_tdata => w_FIR2_tdata(47 downto 0)
    );
    
    --only retain the lower 16 bits of each of the imag and real signals out of FIR_1
    w_FIR2_tdata_sliced <= w_FIR2_tdata(39 downto 24) & w_FIR2_tdata(15 downto 0);
    
    --assign output master axis port signals
    m_axis_tvalid <= w_FIR2_tvalid;
    w_FIR2_tready <= m_axis_tready;
    m_axis_tdata <= w_FIR2_tdata_sliced;
        
	-------------------------- User logic ends --------------------------------------------------------------

end arch_imp;
