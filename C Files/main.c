/*
 * File Name: main.c
 * Purpose: Main Driver for the project's functions
 */
#include "GameFunctions.h"

int main(void) {
setbuf(stdout, NULL); //Allows my program to run in my IDE
srand(time(0)); //Sets the seed for the rand() function being used in my program to the system clock

char input;
int gameLoop = 0; //flag variable for game loop
int selectionLoop; //flag variable for raindrop selection loop
int userNum;

puts("Please enter a character. Press 'p' to play or 'e' to exit.");

//Runs the game loop
while (gameLoop == 0) {

selectionLoop = 0; //resets the flag variable for the raindrop selection loop at each iteration of the game loop
userNum = 0; //resets userNum for each iteration of the game loops

input = getchar();

//Lets the user play the game
if (input == 'p') {

	puts("Select a raindrop to play. Choose a number 1-3 to select your raindrop.");
	scanf("%d", &userNum);
	if ((userNum == 1) || (userNum == 2) || (userNum == 3)) {
		selectionLoop = 1;
	}
	while (selectionLoop == 0) {
	puts("Please enter a valid number. Choose a number 1-3 to select your raindrop.");
	scanf("%d", &userNum);
	if ((userNum == 1) || (userNum == 2) || (userNum == 3)) {
			selectionLoop = 1;
		}
	}

//Initializes 3 Raindrop Objects
struct Raindrop *drop1 = malloc(sizeof(Raindrop));
struct Raindrop *drop2 = malloc(sizeof(Raindrop));
struct Raindrop *drop3 = malloc(sizeof(Raindrop));

//Displays the raindrop simulation
outputGraph(drop1, drop2, drop3);

//Displays a separation between each iteration of the game loop
puts("----------------------------------------------------------");
puts("Please enter a character. Press 'p' to play or 'e' to exit.");

free(drop1);
free(drop2);
free(drop3);
}

//Allows the user to exit the game
else if (input == 'e') {
	gameLoop = 1;
	}

}

return 0;
}
