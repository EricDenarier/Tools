/* This macro calculate the speed of Polymerization and Depol
from the tracks of several kymograph saved in the ROI manager.
The real speed is calculated if the unit of the kymograph are correctly
set (see below)
*/


macro "Slope&Speed 2sec 100X" {
//////////////////// You can change settings here /////////////
var echelle_x = 0.110; // micrometer per pixel
var echelle_y = 0.0333 ; // minutes per pixel
//////////////////////////////////////////////////////////////
run("Set Measurements...", "  mean centroid integrated redirect=None decimal=4");
 
 
 list = getList("image.titles");
    if (list.length!=0) title=getTitle();
  			else exit("There is no open image");
  
  Dialog.create("Scale settings");
  Dialog.addNumber("size of pixel in x dimension (µm)", echelle_x);
  Dialog.addNumber("size of pixel in y dimension (min)", echelle_y);
  Dialog.show();
  echelle_x=Dialog.getNumber();
  echelle_y=Dialog.getNumber();



nROI=roiManager("count");
print ("ROI n       \t elapsed time (min)   \t  Total distance (µm)   \t  Event Duration (min)   \t  Event length (µm)   \t  actual speed (µm/min)   \t");

for (r=0; r<nROI; r++){	

	run("Clear Results");
	roiManager("Select", r); 
	getSelectionCoordinates(x, y);
	sum_dx=0;
	sum_dy=0;     

	for (i=0; i<x.length-1; i++){
		dx_now=(x[i+1]-x[i])*echelle_x;
		sum_dx=sum_dx+dx_now;

		dy_now=abs(y[i+1]-y[i])*echelle_y;
		if (dy_now==0)dy_now=1*echelle_y;
		sum_dy=sum_dy+dy_now;
		print ("ROI n  "+r+1+"          \t          "+sum_dy+"          \t          "+sum_dx+"          \t          "+dy_now+"          \t          "+dx_now+"          \t          "+dx_now/dy_now);

	}}}
