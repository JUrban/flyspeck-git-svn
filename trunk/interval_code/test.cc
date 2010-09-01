#include "error.h"
#include <float.h>
#include <iomanip.h>
#include <iostream>
#include <sstream>
#include <string.h>
#include "interval.h"
#include "lineInterval.h"
#include "secondDerive.h"
#include "taylorInterval.h"
#include "recurse.h"
#include <time.h>
#include <string.h>
#include <stdlib.h>

using namespace std;

void selfTest()
	{
	interMath::selfTest();
	linearization::selfTest();
	secondDerive::selfTest();
	taylorFunction::selfTest();
	}

int testRun()
	{
	interval tx[6]={"4","4","4","6.3001","4","4"};
	interval tz[6]={"6.3001","6.3001","6.3001","6.3001","6.3001","6.3001"};
	domain x = domain::lowerD(tx);
	domain z = domain::upperD(tz);
	taylorFunction F = taylorSimplex::dih*"-1"+taylorSimplex::unit*"1.153093";
	F.setReducibleState(0);
	return prove::generic (x,z,F);
	}

main()
	{
	selfTest();
	cout.precision(20);
	if (testRun()) 
		cout << "YES!"; else cout << "NO!" ;
	cout << "\nhello" << endl;


	}
