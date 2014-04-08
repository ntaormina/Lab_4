/*
 * main.c
 *
 *  Created on: Apr 7, 2014
 *      Author: C15Nikolas.Taormina
 */

#include <xuartlite_l.h>
#include <xparameters.h>
#include <xil_io.h>
#include "Lab_4.h"

int main(void)
{
 while (1)
 {
  unsigned char char1, char2, char3;


  char1 = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, char1);

  char2 = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, char2);

  char3 = XUartLite_RecvByte(0x84000000);
  XUartLite_SendByte(0x84000000, char3);

  if(char1 == 'l' && char2 == 'e' && char3 == 'd'){
	  XUartLite_SendByte(0x84000000, 0x20);
	  unsigned char ledOut = LedLogic();
	  Xil_Out8(0x83000000, ledOut);
  }

  if(char1 == 's' && char2 == 'w' && char3 == 't'){
  	  XUartLite_SendByte(0x84000000, 0x20);
  	  unsigned char swtIn = Xil_In8(0x83000004);
  	  switchLogic(swtIn);

    }

  XUartLite_SendByte(0x84000000, 0x0A);
  XUartLite_SendByte(0x84000000, 0x0D);

 }

 return 0;
}

unsigned char LEDMSB(unsigned char c){
	unsigned char output;
	if(c =='0'){
		output = 0b00001111;
	}else if(c == '1'){
		output = 0b00011111;
	}else if(c == '2'){
		output = 0b00101111;
	}else if(c == '3'){
		output = 0b00111111;
	}else if(c == '4'){
		output = 0b01001111;
	}else if(c == '5'){
		output = 0b01011111;
	}else if(c == '6'){
		output = 0b01101111;
	}else if(c == '7'){
		output = 0b01111111;
	}else if(c == '8'){
		output = 0b10001111;
	}else if(c == '9'){
		output = 0b10011111;
	}else if(c == 'A'){
		output = 0b10101111;
	}else if(c == 'B'){
		output = 0b10111111;
	}else if(c == 'C'){
		output = 0b11001111;
	}else if(c == 'D'){
		output = 0b11011111;
	}else if(c == 'E'){
		output = 0b11101111;
	}else if(c == 'F'){
		output = 0b11111111;
	}else{
		output = 0b11111111;
	}
	return output;
}
unsigned char LEDLSB(unsigned char c){
	unsigned char output;
	if(c =='0'){
		output = 0b11110000;
	}else if(c == '1'){
		output = 0b11110001;
	}else if(c == '2'){
		output = 0b11110010;
	}else if(c == '3'){
		output = 0b11110011;
	}else if(c == '4'){
		output = 0b11110100;
	}else if(c == '5'){
		output = 0b11110101;
	}else if(c == '6'){
		output = 0b11110110;
	}else if(c == '7'){
		output = 0b11110111;
	}else if(c == '8'){
		output = 0b11111000;
	}else if(c == '9'){
		output = 0b11111001;
	}else if(c == 'A'){
		output = 0b11111010;
	}else if(c == 'B'){
		output = 0b11111011;
	}else if(c == 'C'){
		output = 0b11111100;
	}else if(c == 'D'){
		output = 0b11111101;
	}else if(c == 'E'){
		output = 0b11111110;
	}else if(c == 'F'){
		output = 0b11111111;
	}else{
		output = 0b11111111;
	}
	return output;
}
unsigned char asciiToNibbleMSB(unsigned char c){
	unsigned char nibble;
	if(c == 0b00000000){
		nibble = '0';
	}else if(c == 0b00010000){
		nibble = '1';
	}else if(c == 0b00100000){
		nibble = '2';
	}else if(c == 0b00110000){
		nibble = '3';
	}else if(c == 0b01000000){
		nibble = '4';
	}else if(c == 0b01010000){
		nibble = '5';
	}else if(c == 0b01100000){
		nibble = '6';
	}else if(c == 0b01110000){
		nibble = '7';
	}else if(c == 0b10000000){
		nibble = '8';
	}else if(c == 0b10010000){
		nibble = '9';
	}else if(c == 0b10100000){
		nibble = 'A';
	}else if(c == 0b10110000){
		nibble = 'B';
	}else if(c == 0b11000000){
		nibble = 'C';
	}else if(c == 0b11010000){
		nibble = 'D';
	}else if(c == 0b11100000){
		nibble = 'E';
	}else {
		nibble = 'F';
	}
	return nibble;
}
unsigned char asciiToNibbleLSB(unsigned char c){
	unsigned char nibble;
	if(c == 0b00000000){
		nibble = '0';
	}else if(c == 0b00000001){
		nibble = '1';
	}else if(c == 0b00000010){
		nibble = '2';
	}else if(c == 0b00000011){
		nibble = '3';
	}else if(c == 0b00000100){
		nibble = '4';
	}else if(c == 0b00000101){
		nibble = '5';
	}else if(c == 0b00000110){
		nibble = '6';
	}else if(c == 0b00000111){
		nibble = '7';
	}else if(c == 0b00001000){
		nibble = '8';
	}else if(c == 0b00001001){
		nibble = '9';
	}else if(c == 0b00001010){
		nibble = 'A';
	}else if(c == 0b00001011){
		nibble = 'B';
	}else if(c == 0b00001100){
		nibble = 'C';
	}else if(c == 0b00001101){
		nibble = 'D';
	}else if(c == 0b00001110){
		nibble = 'E';
	}else {
		nibble = 'F';

	}
	return nibble;
}
unsigned char LedLogic(){
	unsigned char lastFour, firstFour;
	firstFour = XUartLite_RecvByte(0x84000000);
	XUartLite_SendByte(0x84000000, firstFour);
	lastFour = XUartLite_RecvByte(0x84000000);
	XUartLite_SendByte(0x84000000, lastFour);
	firstFour = LEDMSB(firstFour);
	lastFour = LEDLSB(lastFour);
	return firstFour & lastFour;
}

void switchLogic(unsigned char swt){
	unsigned char firstSWT, lastSWT;
	firstSWT = swt & 0b11110000; //Preserves top four bits
	lastSWT = swt & 0b00001111; //Preserves bottom four bits
	firstSWT = asciiToNibbleMSB(firstSWT);
	lastSWT = asciiToNibbleLSB(lastSWT);
	XUartLite_SendByte(0x84000000, firstSWT);
	XUartLite_SendByte(0x84000000, lastSWT);
}
