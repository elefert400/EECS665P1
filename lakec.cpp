#include <iostream>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include "scanner.hpp"

using namespace lake;

int 
main( const int argc, const char **argv )
{
	if (argc != 3){
		std::cout << "Usage: lakec <infile> <outfile>" 
			<< std::endl;
		return 1;
	}
	int retCode = 0;

	const char * inFile = argv[1];
	const char * outFile = argv[2];
	std::ifstream inStream(inFile);
	if (!inStream.good()){
		std::cerr << "Bad input stream: " 
		<< inFile << std::endl;
		exit(1);
	}
	Scanner scanner(&inStream);
	scanner.outputTokens(outFile);
	return retCode;
}
