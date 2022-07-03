function montage(path,x,y,channel,slice,distance,fraction_area,fraction_number,row,column,savepath) { 
// function description

	open(path);
	run("Duplicate...", "duplicate channels="+channel+"-"+channel+" slices="+slice+"-"+slice);
	rename("img");
	getDimensions(width, height, channels, slices, frames);
	width_=width-x;
	height_=height-y;
	run("Duplicate...", "duplicate");
	run("Subtract Background...", "rolling=50 stack");
	run("8-bit");
	run("Auto Local Threshold", "method=Phansalkar radius=15 parameter_1=0 parameter_2=0 white stack");
	rename("move");
	for (i = 0; i < width_; i=i+distance){
		for (j = 0; j < height_; j=j+distance){
			selectWindow("move");
			makeRectangle(i, j, x, y);
			roiManager("Add");
		}
	}
	
	run("Set Measurements...", "area_fraction limit display redirect=None decimal=8");
	for (m = 0; m < frames; m++){
		selectWindow("move");
		run("Select None");
		run("Duplicate...", "duplicate range="+m+1+"-"+m+1);
		rename("move-1");
		roiManager("Show All");	
		roiManager("Measure");
		Table.sort("%Area");
		rate_array=Table.getColumn("%Area");
		label_array=Table.getColumn("Label");
		len=rate_array.length;
		position=label_array[len-1];
		b=split(position,"-");
		xx=(b[3])-50;
		yy=(b[2])-50;
		selectWindow("img");
		run("Select None");
		run("Duplicate...", "duplicate range="+m+1+"-"+m+1);
		rename("img-1");
		run("Select None");
		makeRectangle(xx, yy, x, y);
		print(xx,yy);
		run("Duplicate...", "duplicate");
		rename(m+1);
		selectWindow("img-1");
		run("Close");
		selectWindow("move-1");
		run("Close");
		run("Clear Results");
		
	}
	roiManager("reset");	
	run("Images to Stack", "use");
	run("Make Montage...", "columns="+column+" rows="+row+" scale=1");
	saveAs("tiff", savepath+"montage.tiff");
	
close("*");
}



fa_path = getDirectory("Choose the Input Directory");
fa_file_list=getFileList(fa_path);	
for (l = 0; l < fa_file_list.length; l++){
	
	path=fa_path+fa_file_list[l]+"/Images//"+"final.tiff";
	savepath=fa_path+fa_file_list[l]+"/Images//";
	montage(path,100,100,1,1,50,20,55,6,10,savepath)
}
