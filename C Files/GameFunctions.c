/*
 * File Name: GameFunctions.c
 * Purpose: Holds source code for the project's functions.
 */
#include "GameFunctions.h"

//Function that picks a random equation to simulate the Raindrop using an RNG
void randomizeDrop(Raindrop *drop, int graphArray[domain][range]) {

	drop->n = rand() % 4;

	for (int i = 0; i < domain; i++) {

		if (drop->n == 0) {
			drop->x = i;
			drop->y = drop->x;
			graphArray[drop->x][drop->y] = '*';
			timeDelay(0.000001);
		}

		else if (drop->n == 1) {
			drop->x = i;
			drop->y = 3 * drop->x - 1;
			graphArray[drop->x][drop->y] = '*';
			timeDelay(0.000002);
		}
		else if (drop->n == 2) {
			drop->x = i;
			drop->y = 4 * drop->x;
			graphArray[drop->x][drop->y] = '*';
			timeDelay(0.000003);
		}
		else if (drop->n == 3) {
			drop->x = i;
			drop->y = pow(drop->x, (0.5));
			graphArray[drop->x][drop->y] = '*';
		}
		}
}

//Function that creates a time delay

void timeDelay(double numSec) {

	//Variables for time delay function
	double milSec;
	clock_t start;

	milSec = numSec * 1000;
	start = clock();

	for (clock_t loop = clock(); loop < (start + milSec); loop = clock()) {
		//Loops until desired delay is met.
	}
}

//Function that outputs graph of all raindrops
void outputGraph(Raindrop *drop1, Raindrop *drop2, Raindrop *drop3) {

	//Code for initializing the display graph
	int graphArray[domain][range];
	for (int i = 0; i < domain; i++) {
			for (int j = range; j > 0; j--) {
				graphArray[i][j] = ' ';
			}
	}

	//Calls the Drop Randomization function to randomize each drop
	randomizeDrop(drop1, graphArray);
	randomizeDrop(drop2, graphArray);
	randomizeDrop(drop3, graphArray);

	//Outputs the display graph
	for (int i = 0; i < domain; i++) {
		for (int j = 0; j < range; j++) {
			printf("%c", graphArray[i][j]);
		}
		timeDelay(0.175); //Implements a delay between printing out each line, causing it to appear incremental
		printf("%s", "\n");
	}


}
