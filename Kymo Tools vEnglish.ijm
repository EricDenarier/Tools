/* Split Vertical Tool : Splits a dual view image in 2 images
the orientation of the split and number of images can be set in the 
tool option

Filter Tool : DoG filters. Substracts image of a large Gaussian Filter
to a small Gaussian Filter. The tool options allow you to select the size 
of the filters adapted for your objects. You can choose a Gaussian Blur or Median Filter for
the small filter. The resulting stack and its maximal projection are reported.

Kymograph Tool : This tool is used to create Kymograph from TimeLapse stack
the width of the line can be set (linewidth)
and it reports the MAXIMAL value across the line width 
for the entire TimeLapse stack to create a x/t image.
The line width can be set in the tool option.

GetLineValue Tool : This tool reports in the Log window in two columns
the intensities of the signal and background along odd line number created from a segmented line. 
 You can can define the line width from which the average 
 or max will be extracted and the distance between signal line and background line 
 in the tool options. 
 The average across the line is always reported for the Background.
 The difference of the mean of the 2 columns gives the Signal-Background.
 This tool can be used to trace the Pol/depolymerisation Event on a microtubule Kymograph and
measure comets intensities on the corresponding EB kymograph. 

AVG Tool : This tool can be used to average frames
to reduce background and increase contrast

Border Tool : Draw a border on an image or stack to make a montage.


*/


var MedBlur="Median";
var DiaBlur = 60;
var DiaMedian = 1;
var Nbre = 5;
var border = 5;
var xpoints;
var ypoints;
var linewidth = 5;
var space=10;
var type="average";

var width=256;
var diviseur=2;
var WorH="V";

macro "SplitVertical Tool - C000F00ffCf00F702f"{
/* Split a dual view image in 2 images
the orientation of the split and number of 
images can be set */


Title=getTitle();
width=getWidth();
height=getHeight();

if (WorH=="V") {
for (i=0; i<diviseur; i++){
selectWindow(Title);
makeRectangle(width/diviseur*i, 0, width/diviseur, height);
run("Duplicate...", "title="+i+" duplicate range=1-nSlices");
}}

if (WorH=="H"){
for (i=0; i<diviseur; i++){
selectWindow(Title);
makeRectangle(0, height/diviseur*i, width, height/diviseur);
run("Duplicate...", "title="+i+" duplicate range=1-nSlices");
}}}

macro "SplitVertical Tool Options" {
   Dialog.create ("Options");
   Dialog.addMessage("In how many pieces do you\n  want to split the image?\n\n");
   Dialog.addNumber("Image Number ",diviseur);
   Dialog.addMessage("In which orientation do you\n  want to split the image ?\n\n H=Horizontal V=Vertical\n\n");
   Dialog.addString("Orientation?  ", "V", 1);
   Dialog.show();
   diviseur = Dialog.getNumber();
   WorH= Dialog.getString();
}



macro "Filter Tool - C000F00ffCf00T0f18M" {

/* filter adpated for small width objects*/


Title=getTitle();
nbreSlices=nSlices;
run("Duplicate...", "  title=[Blur "+DiaBlur+"] duplicate ");
Blur=getTitle();
run("Duplicate...", "title=["+Title+MedBlur+DiaMedian+"] duplicate "); 
Median=getTitle;

run(MedBlur+"...", "radius="+DiaMedian+" stack");
selectWindow(Blur); run("Gaussian Blur...", "sigma="+DiaBlur+" stack");


imageCalculator("Subtract stack", Median,Blur);

if (nbreSlices>1){
run("Z Project...", " projection=[Max Intensity]");
}

selectWindow(Blur); close();
selectWindow(Title); //close();

}

macro "Filter Tool Options" {
   Dialog.create ("Options");
   Dialog.addString("Which Filter: Median or Gaussian Blur ?", MedBlur)
   Dialog.addNumber("Blur Filter Diameter ?: ",DiaBlur);
   Dialog.addNumber(MedBlur+" Filter Diameter ?: ",DiaMedian);
	
   Dialog.show();
   MedBlur = Dialog.getString();
   DiaBlur = Dialog.getNumber();
   DiaMedian = Dialog.getNumber();
}



macro "Kymo Tool - C000F00ffCf00P40d57aceCf00P30c56abeCf00P20b55aae" {

/* This tool is used to create Kymograph from TimeLapse stack
the width of the line can be set (linewidth)
and it reports the maximal value across the line width 
for the entire TimeLapse stack and create a x/t image */

image1=getTitle();
run("Straighten...", "line="+linewidth+" process");
image2=getTitle();

run("Reslice [/]...", "output=1.000 start=Top");
image3=getTitle();


run("Z Project...", " projection=[Max Intensity]");
run("In [+]");
run("In [+]");

selectWindow(image3);
close();
selectWindow(image2);
close();
}

 

macro "Kymo Tool Options" {
   linewidth = getNumber(" Linewidth: ",  linewidth);
}



macro "GetLineValue Tool - C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD1eD1fD20D21D22D23D24D25D26D27D28D29D2aD2bD2cD2dD2eD2fD30D31D32D33D34D35D36D37D38D39D3aD3bD3cD3dD3eD3fD40D41D42D45D46D47D48D49D4aD4bD4eD4fD50D51D52D55D56D57D58D59D5aD5bD5eD5fD60D61D62D65D66D67D68D69D6aD6bD6eD6fD70D71D72D7eD7fD80D81D82D8eD8fD90D91D92D95D96D97D98D99D9aD9bD9eD9fDa0Da1Da2Da5Da6Da7Da8Da9DaaDabDaeDafDb0Db1Db2Db5Db6Db7Db8Db9DbaDbbDbeDbfDc0Dc1Dc2Dc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDcbDccDcdDceDcfDd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDddDdeDdfDe0De1De2De3De4De5De6De7De8De9DeaDebDecDedDeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffCf00D43D44D4cD4dD53D54D5cD5dD63D64D6cD6dD73D74D75D76D77D78D79D7aD7bD7cD7dD83D84D85D86D87D88D89D8aD8bD8cD8dD93D94D9cD9dDa3Da4DacDadDb3Db4DbcDbd"{

/*  This macro reports the intensities of the signal and the background
 along odd line number created from a segmented line. 
 You can can define (parameters below) the line width 
from which the average or max will be extracted (linewidth) and the distance
 between signal line and background line (space). For the background it is always the average across
 the line that will be used
*/


if(isOpen("Results") ==true){
	selectWindow("Results");
	run("Close");}

if(isOpen("ROI Manager") ==true){
	selectWindow("ROI Manager");
	run("Close");}
	
run("Set Scale...", "distance=0");
run("Set Measurements...", "mean redirect=None decimal=0");
run("Line Width...", "line="+linewidth);

print ("--------------------------------------     Start of the Macro     --------------------------------------");

rename("Image");

//setTool("polyline");
//waitForUser("tracer un Kymo");
getSelectionCoordinates(x,y);
roiManager("Add");
for (i=0; i<x.length-1;i=i+2) {

//////////////////////////// Makes line from segmented line every two lines
selectWindow("Image");
makeLine(x[i], y[i], x[i+1], y[i+1]);
roiManager("Add");
intensity(type);


print ("-----  Next Polymerization  -----");
print ("Signal    \t    Background");
value=ypoints;

selectWindow("Image");
makeLine(x[i]+space, y[i], x[i+1]+space, y[i+1]);
roiManager("Add");
intensity("average");
bckgrd=ypoints;

for (j=0;j<bckgrd.length;j++) 	print(value[j]+"  \t   "+bckgrd[j]);

selectWindow("Image");
run("Select None");
							
} // End of For i= line.length
}

macro "GetLineValue Tool Options" {
   Dialog.create ("Options");
   Dialog.addNumber("Line width? ",linewidth);
   Dialog.addNumber("Background line Offset\n in pixel ",space);
   Dialog.addMessage("Reported value for Signal across the line \n(For Background it will always be the average across the line)");
   Dialog.addString(" max or average ?", type);
   Dialog.show();
   linewidth = Dialog.getNumber();
   space = Dialog.getNumber();
   type=Dialog.getString();
}

macro "AVG Tool - C000F00ffCf00T1f18A" {

title=getTitle();
Slices=nSlices;
run("Z Project...", "start=1 stop=46 projection=[Max Intensity]");

setBatchMode(true);
for (i=0;i<Slices-Nbre;i++){
selectWindow(title); 
run("Duplicate...", "title=S_4 duplicate range="+i+"-"+i+Nbre); 

run("Z Project...", "start=1 stop="+Nbre+" projection=[Average Intensity]"); rename ("Z_"+i);
selectWindow("S_4"); close();
}
run("Images to Stack", "name=AVG_Stack title=Z use");
setBatchMode(false);
run("Z Project...", "start=1 stop=46 projection=[Max Intensity]");rename ("MAX AVG stack");

}

macro "AVG Tool Options" {
  Nbre = getNumber("Number of images to average :  ", Nbre);
}



macro "Border Tool - C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D1fD20D2fD30D3fD40D4fD50D5fD60D6fD70D7fD80D8fD90D9fDa0DafDb0DbfDc0DcfDd0DdfDe0DefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC000C111C222C333C444C555C666C777C888C999CaaaCbbbCcccCdddCeeeCfffD11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD1eD21D22D23D24D25D26D27D28D29D2aD2bD2cD2dD2eD31D32D33D34D35D36D37D38D39D3aD3bD3cD3dD3eD41D42D43D44D45D46D47D48D49D4aD4bD4cD4dD4eD51D52D53D54D55D56D57D58D59D5aD5bD5cD5dD5eD61D62D63D64D65D66D67D68D69D6aD6bD6cD6dD6eD71D72D73D74D75D76D77D78D79D7aD7bD7cD7dD7eD81D82D83D84D85D86D87D88D89D8aD8bD8cD8dD8eD91D92D93D94D95D96D97D98D99D9aD9bD9cD9dD9eDa1Da2Da3Da4Da5Da6Da7Da8Da9DaaDabDacDadDaeDb1Db2Db3Db4Db5Db6Db7Db8Db9DbaDbbDbcDbdDbeDc1Dc2Dc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDcbDccDcdDceDd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDddDdeDe1De2De3De4De5De6De7De8De9DeaDebDecDedDee"{

getDimensions(width, height, channels, slices, frames);
newwidth=width+border;
newheight=height+border;
run("Canvas Size...", "width=&newwidth height=&newheight position=Center ");
}

macro "Border Tool Options" {
   border = getNumber("Border size: ", border);
}


function intensity(projec){

run("Straighten...", "title=Image_1 line="+linewidth);rename("Image_1");
run("Reslice [/]...", "output=1.000 start=Top"); rename("Image_2");

if (projec=="max") {run("Z Project...", "projection=[Max Intensity]");rename("Image_3");}
if (projec=="average") {run("Z Project...", "projection=[Average Intensity]");rename("Image_3");}
run("Select All");
run("Plot Profile");
Plot.getValues(xpoints, ypoints);
run("Images to Stack", "method=[Copy (center)] name=Stack title=_ use");
close();
selectWindow("Image_2"); close();
}

