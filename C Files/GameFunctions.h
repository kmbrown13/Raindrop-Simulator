/*
 * File Name: GameFunctions.h
 * Purpose: Allows the GameFunctions.c file to be accessed
 */

#ifndef GAMEFUNCTIONS_H_
#define GAMEFUNCTIONS_H_

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define domain 50
#define range 250

//Struct for Raindrop Object Type
typedef struct Raindrop {
	int x;
	int y;
	int n;
}Raindrop;

//Raindrop Simulation Function
void outputGraph(Raindrop *drop1, Raindrop *drop2, Raindrop *drop3);

//RNG Function
void randomizeDrop(Raindrop *drop, int graphArray[domain][range]);

void timeDelay(double numSec);


#endif /* GAMEFUNCTIONS_H_ */
