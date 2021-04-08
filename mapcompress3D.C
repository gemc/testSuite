// this code read a 3D map file and reduce its size by removing unnecessary digits
// in 6 columns to reduce all coordinates to integer and all B to 0.1 precision
// just run it like root as a root script

#include <iomanip>
#include <iostream>
using namespace std;

void mapcompress3D(string input_filename,int nx,int ny,int nz,int skipline)
{

	ifstream input(input_filename.c_str());
	if (input.good()) cout << "open file " << input_filename << " OK" <<endl;
	else {cout << "can't open the file" << endl; return;}

	ofstream output("output");

	// reads and discard the first few lines of text
	char textline[200];
	for (int k = 0; k<skipline; k++) input.getline(textline,200);

	double x,y,z;
	double  Bx,By,Bz;
	for (int j = 0; j<nx*ny*nz; j++) {
		cout << j << "\r" ;
		input >> x>>y>>z>> Bx>>By>>Bz;

		// 	cout.precision(3);
		// 	cout <<  x << "\t" << y << "\t" << z << "\t";
		// 	cout << scientific << Bx << "\t" << By << "\t" << Bz << endl;

		cout.unsetf ( std::ios::floatfield );
		output << fixed;
		output.precision(0);
		output << x ;
		output << "\t";
		output << y ;
		output << "\t";

		// 	Bx=-Bx;By=-By;Bz=-Bz; //flip field

		if (z>=0) output <<  " ";
		output << z ;
		output.precision(1);
		// 	if (Bx<0.5) {Bx=0;}
		output << "\t";
		if (Bx>=0) output <<  " ";
		output << Bx ;
		// 	if (By<0.5) {By=0;}
		output << "\t";
		if (By>=0) output <<  " ";
		output<< By ;
		// 	if (Bz<0.5) {Bz=0;}
		output << "\t";
		if (Bz>=0) output <<  " ";
		output<< Bz ;
		output<< endl;


		// 	cout.unsetf ( std::ios::floatfield );
		// 	output << fixed;
		// 	output.precision(0);
		// 	output.width(3);
		// 	output << x ;
		// 	output.width(4);
		// 	output << y ;
		// 	output.width(4);
		// 	output << z ;
		// 	output.precision(1);
		// 	if (Bx<0.5) {Bx=0;}
		// 	output.width(9);
		// 	output << Bx ;
		// 	if (By<0.5) {By=0;}
		// 	output.width(9);
		// 	output<< By ;
		// 	if (Bz<0.5) {Bz=0;}
		// 	output.width(9);
		// 	output<< Bz ;
		// 	output<< endl;

		// 	output.precision(0);
		// 	output << fixed;
		// 	output <<  x << " " << y << " " << z << " ";
		// 	output.precision(3);
		// 	output << scientific;
		// 	output << Bx << " " << By << " " << Bz << endl;

		// 	input.getline(textline,200); //get the rest of line
		//       cout.width(10);
		//       cout.setf(0,ios::floatfield);
		//       cout.setf(ios::fixed,ios::floatfield);
		//     cout.precision(6);
		//     cout << scientific <<
		//     cout << R[i][j] << "\t" <<  Z[i][j] <<  "\t" <<  Br[i][j] <<  "\t" <<  Bz[i][j] << endl;
		// 	cout << j << "\t" << i << "\r";
	}
	//     cout << R << "\t" <<  Z <<  "\t" <<  Br <<  "\t" <<  Bz << endl;
	input.close();
	cout << "finish reading in" << endl;

	output.close();

}

