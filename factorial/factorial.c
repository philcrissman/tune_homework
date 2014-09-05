#include <stdio.h>
double factorial(int);
int prompt(void);

int main(void) {
  int n;

  prompt();
  while (scanf("%d", &n) == 1){
    if (n<0) {
      printf("Factorial is only defined for nonnegative n, okay?");
    } else {
      if(n>22) {
        printf("Okay but I think this number is too big.\n");
      }
      printf("Result: %.f\n\n", factorial(n));
    }
    prompt();

  }
  printf("Now we are cosmic friends forever, okay?\n");

  return 0;
}

int prompt(void) {
  printf("plz enter q to quit, okay?\n");
  printf("I'm only using double for a return type, so, I'm going to lose precision and start giving wrong answers at about 22!, okay.\n");
  printf("Plz enter an integer: ");
  return 0;
}

// Since this is a shorter program, I'm not going to worry about 
// the lost precision.

double factorial(int n) {
  double result;

  for (result = 1; n > 1; n--) {
    result *= n;
  }

  return result;
}
