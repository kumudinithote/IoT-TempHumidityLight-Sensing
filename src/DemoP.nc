#include "Timer.h"
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "printf.h"
#include "TestSerial.h"

module DemoP @safe()
{
	//Timer Intersface
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	uses interface Timer<TMilli> as Timer2;
	
	//General Interface
	uses interface Leds;
	uses interface Boot;

	//Rread Temperature Humidity and Light
	uses interface Read<uint16_t> as ReadLight;
	uses interface Read<uint16_t> as TempSensor;
	uses interface Read<uint16_t> as HumiditySensor;
	
	//Radio Interface
	uses interface SplitControl as RadioControl;
	uses interface SplitControl as AMControl;
	uses interface AMSend;
	uses interface Receive;
	uses interface Packet;
	uses interface AMPacket;
	
	
}
implementation
{
	message_t buf;
	message_t *receivedBuf;
	bool radioBusy = FALSE;
	uint8_t lightBool;
	uint8_t tempBool;
	uint8_t humidityBool;
	task void readTempSensor();
	task void readLightSensor();
	task void readHumiditySensor();
	task void sendPacket();
	

	event void Boot.booted()
	{
		call RadioControl.start();
		call AMControl.start();
	}

	event void RadioControl.startDone(error_t err)
	{
		if(err == SUCCESS)
		{	
			
			if(TOS_NODE_ID == 1){
				call Timer0.startPeriodic(1000);
				call Timer1.startPeriodic(2000);
				call Timer2.startPeriodic(4000);
				
			}
		}else
		{
			call AMControl.start();
		}
		
	}
		

	event void Timer0.fired()
	{
		post readTempSensor();
		//call ReadLight.read();
		if(call TempSensor.read() == SUCCESS)
			call Leds.led0Toggle();
		
	}
	
	event void Timer1.fired()
	{
		post readLightSensor();
		//call ReadLight.read();
		if(call ReadLight.read() == SUCCESS)
			call Leds.led1Toggle();
		
	}
	
	event void Timer2.fired()
	{
		post readHumiditySensor();
		//call ReadLight.read();
		if(call HumiditySensor.read() == SUCCESS)
			call Leds.led2Toggle();
		
	}
	

	
	event void AMControl.startDone(error_t err){}
	event void AMControl.stopDone(error_t err){}
	

	//sensing the reading ans calling the read done
	task void readTempSensor()
	{
		
		if(call TempSensor.read() != SUCCESS)
			post readTempSensor();
		
		
	}
	
	task void readLightSensor()
	{
		if(call ReadLight.read() != SUCCESS)
			post readLightSensor();
		
	}
	task void readHumiditySensor()
	{

		if(call HumiditySensor.read() != SUCCESS)
			post readHumiditySensor();
		
	}

	//Sending packet to receive and setting bool value	
	event void ReadLight.readDone(error_t err, uint16_t value)
	{

		if(err == SUCCESS)
		{	
			//Packet create and send.
			Mote2Base* btrpkt = (Mote2Base*)(call Packet.getPayload(&buf, sizeof (Mote2Base)));			
			btrpkt->lightBool = value;
			btrpkt->light = 1;
			btrpkt->temp = 0;
			btrpkt->humidity = 0;
			
			post sendPacket();
			//printf("Photo %d \r\n", value);
			//printfflush();
		}
		else
		{
			post readLightSensor();
		}
	}

	event void TempSensor.readDone(error_t err, uint16_t value)
	{

		if(err == SUCCESS)
		{	
			
			Mote2Base* btrpkt = (Mote2Base*)(call Packet.getPayload(&buf, sizeof (Mote2Base)));			
			btrpkt->tempBool = value;
			btrpkt->light = 0;
			btrpkt->temp = 1;
			btrpkt->humidity = 0;
			
			post sendPacket();
			//printf("temp %d \r\n", value);
			//printfflush();
		}
		else
		{
			post readTempSensor();
		}
	}
	
	event void HumiditySensor.readDone(error_t err, uint16_t value)
	{

		if(err == SUCCESS)
		{	
			
			Mote2Base* btrpkt = (Mote2Base*)(call Packet.getPayload(&buf, sizeof (Mote2Base)));			
			btrpkt->humidityBool = value;
			btrpkt->light = 0;
			btrpkt->temp = 0;
			btrpkt->humidity = 1;
			
			post sendPacket();
			//printf("humidity %d \r\n", value);
			//printfflush();
		}
		else
		{
			post readHumiditySensor();
		}
	}

	
	
	task void sendPacket()
	{
		if(call AMSend.send(AM_BROADCAST_ADDR, &buf,sizeof(Mote2Base)) != SUCCESS)
			post sendPacket();
	}
	

	event void AMSend.sendDone(message_t *msg, error_t err)
	{
		if(err !=  SUCCESS)
		{
			post sendPacket();
		}
	}

	event void RadioControl.stopDone(error_t err)
	{}
	//Printing readings on simulator

	event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len)
	{
				
		if(len != sizeof(Mote2Base)){return msg;}
		else{
			Mote2Base* demoPayload = (Mote2Base*)payload;
			uint16_t light = (uint16_t)demoPayload->light;
			uint16_t temp = (uint16_t)demoPayload->temp;
			uint16_t humidity = (uint16_t)demoPayload->humidity;
			if(light == 1){
				uint16_t value = (uint16_t)demoPayload->lightBool;
				printf("Photo : %d \r\n", value);
				 call Leds.led0Toggle();
			}
			
			if(temp == 1){
				uint16_t value1 = (uint16_t)demoPayload->tempBool;
				printf("Temprature : %d \r\n", value1);
				call Leds.led1Toggle();
			}
			
			if(humidity == 1){
				uint16_t value2 = (uint16_t)demoPayload->humidityBool;
				printf("Humidity : %d \r\n", value2);
				call Leds.led2Toggle();
			}
			

			printfflush();
			return msg;
		}
		
	}
	 
}
