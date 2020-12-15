#include "TestSerial.h"
#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration DemoAppC
{
}
implementation
{
	components MainC, DemoP, LedsC, new HamamatsuS10871TsrC() as LightSensor;
	components ActiveMessageC;
	components new AMSenderC(AM_DEMO_MESSAGE), new AMReceiverC(AM_DEMO_MESSAGE);
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;
	
	components SerialActiveMessageC as SerialC;
	components PrintfC;
  	components SerialStartC;
	components new SensirionSht11C() as Temp;
	
	DemoP-> MainC.Boot;
	DemoP.Timer0->Timer0;
	DemoP.Timer1->Timer1;
	DemoP.Timer2->Timer2;
	
	DemoP.ReadLight->LightSensor;
	DemoP.Leds-> LedsC;
	DemoP.RadioControl->ActiveMessageC;
	DemoP.AMControl->SerialC;
	DemoP.AMSend->AMSenderC;
	DemoP.Receive->AMReceiverC;
	DemoP.Packet->AMSenderC;
	DemoP.AMPacket->AMSenderC;
		
	DemoP.TempSensor->Temp.Temperature;
	DemoP.HumiditySensor->Temp.Humidity;
	
}
