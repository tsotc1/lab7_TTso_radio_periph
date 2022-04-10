

/***************************** Include Files *******************************/
#include "radio_tuner.h"

/************************** Function Definitions ***************************/
// set the frequency of the Fake ADC component
// it calculates the necessary phase increment value based on the input freq
void radioTuner_setAdcFreq(u32 BaseAddress, float freq)
{
	float Fs = 125e6;	//sample frequency of DDS
	u32	phaseWidth = 134217728;	//max value of the phase accumulator = 2^phaseWidth
	u32 phaseInc = freq/Fs *  phaseWidth;
	
	//write to the Fake ADC's DDS_PINC register
	RADIO_TUNER_mWriteReg(BaseAddress, RADIO_TUNER_S00_AXI_SLV_REG0_OFFSET, phaseInc);
}

// set the frequency of the tuner/Local Oscillator
void radioTuner_tuneRadio(u32 BaseAddress, float tune_frequency)
{
	float Fs = 125e6;	//sample frequency of DDS
	u32	phaseWidth = 134217728;	//max value of the phase accumulator = 2^phaseWidth
	u32 phaseInc = tune_frequency/Fs *  phaseWidth;
	
	//write to the LoDDS_PINC register
	RADIO_TUNER_mWriteReg(BaseAddress, RADIO_TUNER_S00_AXI_SLV_REG1_OFFSET, phaseInc);
}
// reset the Fake ADC and tuner DDSs
// reset = 1 issues the reset
void radioTuner_controlReset(u32 BaseAddress, u8 resetval)
{
	RADIO_TUNER_mWriteReg(BaseAddress, RADIO_TUNER_S00_AXI_SLV_REG2_OFFSET, resetval);
}