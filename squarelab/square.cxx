#include <FL/Fl.H>
#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Output.H>
#include <math.h>
extern double a,b,c,d,x1,x2; 
static char one[20], two[20], none[20]; 
static FILE *A, *B, *C; 
static int N1, N2, N0; 
extern "C" void discr(void); 
Fl_Output *OneRoot, *TwoRoots, *NoRoots;
Fl_Button *One=(Fl_Button *)0;

static void cb_One(Fl_Button*, void*) {
  if (fscanf(A,"%lf",&a)==EOF) return;
if (fscanf(B,"%lf",&b)==EOF) return;
if (fscanf(C,"%lf",&c)==EOF) return; // d=b*b-4*a*c;
 discr();
printf("%lf %lf %lf %lf %lf %lf\n",a,b,c,d,x1,x2);
flush(stdout);

if (d<0) N0++;
if (d==0) N1++; 
if (d>0) N2++;
}

Fl_Button *Many=(Fl_Button *)0;

static void cb_Many(Fl_Button*, void*) {
  if( !feof(B))
 while(!feof(A))
 
 cb_One(NULL,NULL);
 
sprintf(none,"%d", N0);
sprintf(one,"%d", N1);
sprintf(two,"%d", N2);
OneRoot->value(one);
TwoRoots->value(two);
NoRoots->value(none);
}


int main(int argc, char **argv) {
  Fl_Double_Window* w;
  A=fopen("a.dat","r");
  B=fopen("b.dat","r");
  C=fopen("c.dat","r");
  N0=N1=N2=0;
  { Fl_Double_Window* o = new Fl_Double_Window(425, 230);
    w = o; if (w) {/* empty */}
    { One = new Fl_Button(25, 10, 65, 35, "\320\236\320\264\320\275\320\276");
      One->callback((Fl_Callback*)cb_One);
    } // Fl_Button* One
    { Many = new Fl_Button(25, 55, 65, 35, "\320\234\320\275\320\276\320\263\320\276");
      Many->callback((Fl_Callback*)cb_Many);
    } // Fl_Button* Many
    { OneRoot = new Fl_Output(315, 105, 105, 30, "1 \320\272\320\276\321\200\320\265\320\275\321\214");
    } // Fl_Output* OneRoot
    { TwoRoots = new Fl_Output(315, 145, 105, 30, "2 \320\272\320\276\321\200\320\275\321\217");
    } // Fl_Output* TwoRoots
    { NoRoots = new Fl_Output(315, 185, 105, 30, "\320\235\320\265\321\202 \320\272\320\276\321\200\320\275\320\265\320\271");
    } // Fl_Output* NoRoots
    o->end();
  } // Fl_Double_Window* o
  w->show(argc, argv);
  return Fl::run();
}
