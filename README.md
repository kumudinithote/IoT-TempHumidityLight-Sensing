# IoT-TempHumidityLight-Sensing
sensing Temperature Light and Humidity using nesC and cooja simulator


How to run the code on Cooja Simulator.

Make a command on the terminal in assignment directory
1) make telosb

Make a command on another terminal in cooja directory
2)ant run

The code will compile and Cooja simulator window will pop up.

3)Select new file in File dropdown and hit on Create.

4)Hit Motes->add Motes-> Create New Motes-> SKY Motes

5)Browse for the main.exe file. 

6) Select number of motes as 2 check for the speed limit at 100% and Hit Start.

The Desired output will be shown Mote Output Like this:

00:05.492	ID:2	~EdTemprature : 6360
00:06.453	ID:2	~~EdPhoto : 100
00:06.458	ID:2	d~~EdPhoto : 93
00:06.466	ID:2	~~EdTemprature : 6360
00:07.448	ID:2	~~EdTemprature : 6360
00:08.411	ID:2	~~EdPhoto : 86
00:08.419	ID:2	c~~EdPhoto : 79
00:08.428	ID:2	~~EdTemprature : 6360
00:08.440	ID:2	~~EdHumidity : 4160
00:09.395	ID:2	u~~EdTemprature : 6360
00:10.361	ID:2	~~EdPhoto : 72 
