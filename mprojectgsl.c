#include <stdio.h>
#include <string.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>

//Note ints limit 2147483647
#define L 3 //colums
#define M 4 //rows
#define WRAPX 1
#define WRAPY 0
#define RESTRICT(x, L) (((x) >= 0) ? ((x) % (L)) : ((x) + (L)))  // Restrict x to the interval [0:L-1]
                                                                 // This is needed for wrapping
                                                                 // Note: does not work when x < -L
#define SITE(x, y, L, M) (RESTRICT((x), (L)) + RESTRICT ((y), (M)) * (L) )  // Site index

//#define P 500
#define bins 35

int fillH(double H[L*M][L*M]); //Generates the Hamiltonian
int setvacancies(double H[L*M][L*M], double percent_a, double percent_b, double value); //Sets some diagonal values to high potentials to add vacancies
int printH(double H[L*M][L*M]); //Prints the Hamiltonian matrix
gsl_vector* geteigen(double H[L*M][L*M]); //Gets eigenvalues of H, could be modified to get eigenvectors if necessary
int printeigenvalues(gsl_vector* eval); //Prints the eigenvalues obtained
int sprinteigenvalues(gsl_vector* eval, double output[]);
double genhistogram (double minval, double maxval, double input[], int output[bins], int P);
int avhistogram (int output[bins], double avhist[bins], int n);
double myrand();

double myrand(){
  return (double) (rand()/((double) RAND_MAX));
}


double genhistogram (double minval, double maxval, double input[], int output[bins], int P) //P is length of input
{
  memset (output, 0, sizeof (output[0]) * bins);
  double binsize = 0.0;
  int j, k, m;
  printf("P=%i\n", P);
  binsize = (maxval - minval) / bins;
  
  for (j=0; j<P; j++)
    {
      k = floor((input[j]-minval) / (binsize)); // was: ... * binsize!
      if (k>=0 && k<bins)
	output[k]++;
    }
  for (m=0; m<bins; m++)			/* just prints out the number of elements in each bin */
    {
      printf("%d ",output[m]);
    }
  printf("\n");
  
  return binsize;
}

int avhistogram (int output[bins], double avhist[bins], int n)
{
	int j;

	for (j=0; j<bins; j++)
	{
		avhist[j] *= n-1;
		avhist[j] += output[j];
		avhist[j] /= n;
		output[j] = 0;
	}

	for (j=0; j<bins; ++j)			/* prints out the values in the histogram average array */
	{
		printf("%f ",avhist[j]);
	}
	printf("\n");

	return 0;
}

int fillH(double H[L*M][L*M]){
  int x=0;
  int y=0;
  for (y = 0; y < M; y ++) {
    for (x = 0; x < L; x++) {
      int current     = SITE (x, y, L, M);
      int col_stagger = (x % 2) ? 1 : -1;
      int row_stagger = (y % 2) ? 1 : -1;
      int ab_stagger  = col_stagger * row_stagger; // +1 on A, -1 on B sublattice
      int h_neigh     = SITE (x + ab_stagger, y, L, M); // horizontal neighbour,
                                                        // left or right, depending on AB
      int up_neigh    = SITE (x, y + 1, L, M);          // A neighbour upstairs
      int down_neigh  = SITE (x, y - 1, L, M);          // A neighbour downstairs

      if ((y < M - 1) || WRAPY ) { //link above
          H[current][up_neigh] = 1;
      }

      if ((y > 0) || WRAPY) {      //link below
          H[current][down_neigh] = 1;
      }

      if (((x > 0) && (x <  L - 1)) || WRAPX)
           H[current][h_neigh] = 1;
      }

  }
  return 0;
  //array is always Hermitian or symmetric so should only need
  //to run on half the values - fix this!

}


int setvacancies(double H[L*M][L*M], double percent_a, double percent_b, double value)
{
    int x=0;
    int y=0;
    int p=0;

    for (p=0;p<M*L;p++)
    {
        x=p%L;
        y=p/L;
        int col_stagger = (x % 2) ? 1 : -1;
        int row_stagger = (y % 2) ? 1 : -1;
        int ab_stagger  = col_stagger * row_stagger;  // This gives a simple way to distingish a,b sublattice: a=1 b=-1

        double num= myrand();
        double expected = (ab_stagger==1)?percent_a:percent_b;
        if (num<=expected)
            H[p][p]=value;


    }


    return 0;
}

int printH(double H[L*M][L*M]){
  //Print Hamiltonian
  int i=0;
  int j=0;
  while (j<(L*M)){
    while (i<(L*M)){
      printf("%.0f ", H[j][i]);
      i++;
    }
    i=0;
    j++;
    printf("\n");
  }
  return 0;
}

gsl_vector* geteigen(double H[L*M][L*M]){
  gsl_matrix_view m = gsl_matrix_view_array (*H, L*M, L*M);
  gsl_vector *eval = gsl_vector_alloc (L*M); 
  //gsl_matrix *evec = gsl_matrix_alloc (L*M, L*M);
  gsl_eigen_symm_workspace * w = gsl_eigen_symm_alloc (L*M); //Just worry about eigenvalues for now
  //gsl_eigen_symmv_workspace * w = gsl_eigen_symmv_alloc (L*M);
  gsl_eigen_symm (&m.matrix, eval, w);
  //gsl_eigen_symmv (&m.matrix, eval, evec, w);
  //eigenvalues are symmetric so really only need half, don't think this can be fixed though

  gsl_eigen_symm_free (w);

  return eval;

  //Can modify this to get eigenvectors too, but will need to return an array of a gsl_vector and a gsl_matrix
}

int printeigenvalues(gsl_vector* eval){
  //gsl_eigen_symmv_sort (eval, evec, GSL_EIGEN_SORT_ABS_ASC);
  int i=0;

  for (i = 0; i < L*M; i++)
    {
    double eval_i = gsl_vector_get (eval, i);
    //gsl_vector_view evec_i = gsl_matrix_column (evec, i);
    printf ("%g\n", eval_i); //eigenvalue
    //printf ("eigenvector = \n");
    //gsl_vector_fprintf (stdout, &evec_i.vector, "%g");
    }
  gsl_vector_free (eval); //note this means function can be used only once
  //gsl_matrix_free (evec);
  return 0;
}

int sprinteigenvalues(gsl_vector* eval, double output[]){
  //gsl_eigen_symmv_sort (eval, evec, GSL_EIGEN_SORT_ABS_ASC);
  int i=0;

  for (i = 0; i < L*M; i++)
    {
    double eval_i = gsl_vector_get (eval, i);
    //gsl_vector_view evec_i = gsl_matrix_column (evec, i);
    //printf ("%g\n", eval_i); //eigenvalue
    output[i]=eval_i;
    //printf ("eigenvector = \n");
    //gsl_vector_fprintf (stdout, &evec_i.vector, "%g");
    }
  gsl_vector_free (eval);
  //gsl_matrix_free (evec);
  return 0;
}

int main(){

  int output[bins] = {0};			/* this is the single output array */
  double avhist[bins] = {0.0};	/* this is the average of the histograms */
  // create Hamiltonian
  static double H[L*M][L*M]={0}; //static used to stop segfaults
  fillH(H);
  //setvacancies(H, 0.1,0.1, 99);
  printH(H);
  gsl_vector *eval=geteigen(H);
  double eigenvalues[L*M];
  //printeigenvalues(eval);
  //printf("\n---\n");
  sprinteigenvalues(eval, eigenvalues);
  int i;
  /* for (i=0;i<L*M;i++){ */
  /*   printf("%.3f\n", eigenvalues[i]); */
  /* } */
  int histogram[bins];
  double binsize;
  binsize = genhistogram(-3.0, 3.0, eigenvalues, histogram, L*M);
  printf("binsize = %.4f\n", binsize);
  for (i=0;i<bins;i++){
    printf("%i\n", histogram[i]);
  }  

  //Before we can use Will's histogram code must convert gsl_vector to normal array, will do this later
  /* n = 0; */

  /* for (j=0; j<20; ++j) */
  /*   { */

  /* 	  genhistogram(30, 70, input, output); */
  /* 	  ++n; */
  /* 	  avhistogram(output, avhist, n); */
  /*   } */


  return 0;
}
