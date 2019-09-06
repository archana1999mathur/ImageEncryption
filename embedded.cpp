#include <bits/stdc++.h>

using namespace std;

int main (){

//decalaring all matrixes we would require
	

// .................ENCRYPTION.....................
//..................................................
		 
//taking user input of 8*8 integer matrix................
		int row,col;
		 cin>>row>>col;


		 std::vector<vector <int>> input(row,vector<int> (col));
		 vector<vector <int>> t1(row,vector<int> (col));
		 vector<vector <int>> t2(row,vector<int> (col));
		 vector<vector <int>> t3(row,vector<int> (col));
		 vector<vector <int>> output(row,vector<int> (col));
		 vector<vector <int>> t4(row,vector<int> (col));
		 vector<vector <int>> t5(row,vector<int> (col));

	


// creating two random vectors.....................
	std::vector<int> kr;
	std::vector<int> kc;
	for (int i = 0; i < row; ++i)
	{
		//int temp = rand()%row;
		int temp;
		cin>>temp;
		kr.push_back(temp);
	}

	for (int i = 0; i < col; ++i)
	{
	
		int temp ;
		cin>>temp;
		kc.push_back(temp);
	}

for (int i = 0; i < row; ++i)
	{
	// vector<int> tempv;
	for (int j = 0; j <col; ++j)
	{
		cin>>output[i][j];
	}

	// input.push_back(tempv);
	}

//rotating rows of the matrix................................

// 	for (int i = 0; i < row; ++i)
// 	{
// 		if(kr[i]%2)
// 		{
// 			for (int j = 0; j < col; j++)
// 			{
// 				t1[i][j] = input[i][(j+kr[i])%col];

// 			}
// 		}
// 		else
// 		{
// 			for (int j = 0; j < col; j++)
// 			{
// 				t1[i][j] = input[i][(j+col-kr[i])%col];

// 			}
// 		}
	
// 	}

// //rotating colulmns of the matrix.................................

// 	for (int j = 0; j < col; ++j)
// 	{
// 		if(kc[j]%2)
// 		{
// 			for (int i = 0; i < row; ++i)
// 			{
// 				t2[i][j] = t1[ (i+kc[j])%row ][ j ];
// 			}
// 		}
// 		else
// 		{
// 			for (int i = 0; i < row; ++i)
// 			{
// 				t2[i][j] = t1[(i+row-kc[j])%row][j];
// 			}
// 		}
	
// 	}



		
// //inverting each element by taking bitwise xor with 255

// for (int i = 0; i < row; ++i)
// 	{
// 	for (int j = 0; j <col; ++j)
// 	{
	
// 		  output[i][j] = (t2[i][j])^255;
		
// 	}
		
// 	}

// //............................DECRYPTION................................
// 	//..........................................................

// // for (int i = 0; i < row; ++i)
// // 	{
// // 	for (int j = 0; j < col; ++j)
// // 	{
	
// // 		  cout<<output[i][j]<<" ";
		
// // 	}
// // 		cout<<endl;
// // 	}


// inverting back by taking bitwise xor with 255...................

	for (int i = 0; i < row; ++i)
	{
	for (int j = 0; j <col; ++j)
	{
	
		  t3[i][j] = (output[i][j])^255;
		
	}
		
	}

// reverse rotating columns............................
for (int j = 0; j < col; ++j)
	{
		if(kc[j]%2)
		{
			for (int i = 0; i < row; ++i)
			{
				t4[i][j] = t3[(i+row-kc[j])%row][j];
			}
		}
		else
		{
			for (int i = 0; i < row; ++i)
			{
				t4[i][j] = t3[(i+kc[j])%row][j];
			}
		}
	
	}

//reverse rotating rows...............................................
	for (int i = 0; i < row; ++i)
	{
		if(kr[i]%2)
		{
			for (int j = 0; j < col; j++)
			{
				t5[i][j] = t4[i][(j+col-kr[i])%col];
			}
		}
		else
		{
			for (int j = 0; j < col; j++)
			{
				t5[i][j] = t4[i][(j+kr[i])%col];
			}
		}
	
	}

// printing the decrypted file . It should be same as user input matrix..................
	for (int i = 0; i < row; ++i)
	{
	for (int j = 0; j < col; ++j)
	{
	
		  cout<<t5[i][j]<<" ";
		
	}
		cout<<endl;
	}






	return 0;
}