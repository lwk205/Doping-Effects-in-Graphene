#include <Python.h>
#include <math.h>

static PyObject * errorObject; 

#define SET_ERROR (message) \
   {                       \
       PyErr_SetString(errorObject, message); \
   }                   
#define ON_ERROR (message) \
   {                       \
       PyErr_SetString(errorObject, message); \
       return NULL;                          \
   }


static
PyObject * GetTrans (PyObject * self, PyObject * args) {
          int Lx, Ly; 
          int wrap; 
	  int i; 
          double energy, flux;
          double *transvals;
          double check; 
          char *current_dir; 
          char *gauge_dir; 
          PyObject *retval; 
          PyObject *tval_list;
   
          double gettrans_ (char *current_dir, char *gauge_dir, 
			    double *t, int *Lx, int *Ly, 
			    double *E, double *F, int *w); 
   
          if (!PyArg_ParseTuple (args, "ssiiddi", 
				 &current_dir, &gauge_dir, 
				 &Lx, &Ly, &energy, &flux, &wrap)) {
	       PyErr_SetString(errorObject, "invalid arguments to GetTrans");
	       return NULL; 
	  }
          
          transvals = PyMem_New (double, Lx); 
          
          check = gettrans_ (current_dir, gauge_dir, transvals,  
			     &Lx, &Ly, &energy, &flux, &wrap); 
          
          //fprintf (stderr, "gettrans: %g %g\n", check, transvals[0]); 
          tval_list = PyList_New (Lx); 
          for (i = 0; i < Lx; i++) {
	       PyList_SetItem (tval_list, i, 
			       Py_BuildValue ("d", transvals[i])); 
	  }
          
          PyMem_Free (transvals); 
          
          retval = Py_BuildValue ("Nd", tval_list, check); 
          return retval; 
}


static struct PyMethodDef module_methods[] = {
   { "gettrans", GetTrans, METH_VARARGS, "Calculates transmission values" }, 
   { NULL,       NULL,     0,            NULL}
};


void init_tmatrix () {
     PyObject *module, *moduleDict; 
     PyMethodDef *def; 
     module = Py_InitModule ("_tmatrix", module_methods); 
     moduleDict = PyModule_GetDict (module); 
     errorObject = Py_BuildValue("s", "_tmatrix.error"); 
     if (PyErr_Occurred()) {
         Py_FatalError ("cannot initialize the module _tmatrix"); 
     }
}
