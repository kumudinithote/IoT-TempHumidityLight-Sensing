
#ifndef TEST_SERIAL_H
#define TEST_SERIAL_H

enum {
 	AM_DEMO_MESSAGE = 6
 };

 typedef nx_struct Mote2Base 
 {
  nx_uint16_t nodeid;
  nx_uint16_t lightBool;
  nx_uint16_t tempBool;
  nx_uint16_t humidityBool;
  nx_uint16_t light;
  nx_uint16_t temp;
  nx_uint16_t humidity;
  }Mote2Base;

#endif
