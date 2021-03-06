# Currency-Recogniser-and-Counter-System
The system based on the computer communicates with web cam, catches video frames which include a visible image of currency amount and processes them. Various methodologies are used on the surface of the image. The selected area of the image is processed and analyzed with it’s parameters. Once the image of the currency amount was detected, its digit is recognized. Each note is then stored in a cabinet reserved for that denomination. At the end the total amount is displayed on the user interface.

![Block Diagram](https://github.com/vv258/Currency-Recogniser-and-Counter-System/blob/master/images/1.png)


The bundle of notes, to be counted will be placed in the note feeding unit. The user then pushes the START button in the GUI. The note feeding unit feeds the note, one by one, to the conveyor belt. Sensors are placed at various points on the conveyor belt, which detects the presence of the note. The conveyor is stopped when the note reaches the fake note detection unit. The unit checks whether the note is fake or not. Then the conveyor is restarted. After passing the fake note detection unit, the note move again on the conveyor until it will pass another sensor. This sensor is to detect the presence of the note and stops the conveyor once the note is under the camera.
Once the note is under the camera, data will be sent serially to MATLAB to start capturing the image of the note and do the image processing in MATLAB. After processing, the data will be sent to controller serially from MATLAB ad controller will make decision about the category of the note. The decision or signal will be sent to the twister to move the correct cabinet under the conveyor so that the note will fall into respective cabinet. The twister consists of on a rotating platform driven by a stepper motor. The stepper motor is controlled by the microcontroller. Cabinets for various denominations are mounted on the twister. Once the process is completed, the recognition amount of the currency and the itemized bill are displayed on the Graphical User Interface (GUI).

![Flow Chart](https://github.com/vv258/Currency-Recogniser-and-Counter-System/blob/master/images/2.png)


More Details at: [Hackster.io](https://www.hackster.io/vipinvngpl1992/currency-recognizer-and-counter-system-cbfbee "Currency Recogniser and Counter System")
