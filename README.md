Lab_4 PicoBlaze and Microblaze
==============================

Introduction
============
The purpose of this lab was to make picoblaze and microblaze processors to be implemented on an FPGA. The purpose of Picoblaze was to be able to program in assembly while microblaze was to be able to utilize C. The end goal was to light up the LEDs with input from console and read the HEX value of he switches.

Implementation
==============
-I started by making nibble to ascii and ascii to nibble in both pico and micro blaze.
-Then I made clk to baud the correct rate
-then I connected everything in hardware and moved on to assembly/C
-from there I made programs that read 3 characters, decided if they were "led" or "swt" and then took the appropriate action
-I handled both the LEDs and Switches 4 bits at a time

Testing and Debugging
=====================
-To test these labs I essentially programmed the bit file and diagnosed the problem from there. I didn't run into any big issues with microblaze but a few with pico.

-At first I couldn't even echo with picoblaze but then I realized that my assembly was returning a new line every time. I made it wait for inputs and made sure the hardware was hooked up correctly and it worked!

Conclusion
==========

This lab taught me a lot about the capability of the FPGA to design processors. This is knowledge that I will take with me through working in industry. I learned a lot more about how to us VHDL and now have a greater appreciation for FPGAs. NExt time I will have the correct version of the software so I don't wrestle with pointless errors.

Documentation
=============
I got help on this lab from C2C Ryan Good, C2C Michael Bentley, and C2C Colin Busho. Ryan essentially advised me that I could hard code the output of the leds and input to the switches 4 bits at a time instead of making one method. C2C Bentley gave me advice on how to take three characters as opposed to just the one. Colin helped me with the VHDL file for the switches. I had no idea how to do any of it without him. C2C John Miller helped me debug my Picoblaze portion as well.
