#include <unistd.h>
#include <iostream>
#include <cstdlib>
#include <signal.h>
#include <string.h>
#include <time.h>
using namespace std;
// Define the function to be called when ctrl-c (SIGINT) is sent to process
void signal_callback_handler(int signum) {
   cout << "Caught signal " << signum << endl;
   // Terminate program
   exit(signum);
}
void puts(string output) {
  cout << output << endl;
}
int main(){
   clock_t tStart = clock();
   puts (to_string(tStart));
   // Register signal and signal handler
   signal(SIGINT, signal_callback_handler);
   double timeTaken = (double)(clock() - tStart)/CLOCKS_PER_SEC;
   puts ("Time taken: " + to_string(timeTaken));
   return EXIT_SUCCESS;
}
