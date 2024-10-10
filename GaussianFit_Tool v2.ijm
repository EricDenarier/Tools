

macro "GaussianFit Tool - C000D58D75D96DddDeeC000D1eD2dC000D66C000DcbC000Db9C000Da7C000DfeC000D3bC000C111D49C111D57DffC111D0fC111D0eC111D1fD2fD3fD4fD5fD6fD7fD8fD9fDafDbfDcfDdcDdfDefC111C222D95C222DedC222D2cC222C333DcaC333D65C333D84Db8C333D1dC444D74C444C555D3aC555Da6C555D48C555C666C777D56C777C888DfdC888DdbC888C999CaaaDc9CaaaD0dCaaaDf0CaaaDb7CaaaD2bCaaaD00CaaaCbbbD94DecCbbbD39CbbbCcccD47CcccDfcCcccDf1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbCcccD64CcccDa5CcccCdddD01D02D03D04D05D06D07D08D09D0aD0bD0cD10D20D30D40D50D60D70D80D90Da0Db0Dc0Dd0De0CdddD1cCdddCeeeD55CeeeDdaCeeeDc8CeeeD83CeeeCfffD73Db6CfffD2aCfffD38CfffD46CfffDebCfffDa4CfffD1bD93Dc7Dd9CfffD11D12D13D14D15D16D17D18D19D1aD21D22D23D24D25D26D27D28D29D31D32D33D34D35D36D37D41D42D43D44D45D51D52D53D54D61D62D63D71D72D81D82D91D92Da1Da2Da3Db1Db2Db3Db4Db5Dc1Dc2Dc3Dc4Dc5Dc6Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8De1De2De3De4De5De6De7De8De9Dea"{
nROI=roiManager("count");
title=getTitle();
for (i = 0; i < nROI; i++) {
	selectWindow(title);

roiManager("select", i);
run("Plot Profile");title2=getTitle();
Plot.getValues(xpoints, ypoints);
Fit.doFit("Gaussian", xpoints, ypoints);
Fit.logResults;
Fit.plot; rename(i);
close(title2);close(i);

sigma=Fit.p(3);
print (title+"     \t     "+i+"     \t     sigma= \t    "+sigma+"     FWMH=  \t     "+2.35*sigma);


}
roiManager("deselect");roiManager("reset");