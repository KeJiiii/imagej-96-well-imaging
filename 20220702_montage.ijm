function montage(path,x,y,channel,slice,distance,fraction_area,fraction_number,row,column) { 
// function description

	open(path);
	run("Duplicate...", "duplicate channels="+channel+"-"+channel+" slices="+slice+"-"+slice);
	img=getTitle();
	getDimensions(width, height, channels, slices, frames);
	width_=width-y;
	height_=height-x;
	for (i = 0; i < width_; i=i+distance){
		for (j = 0; j < height_; j=j+distance){
			selectWindow(img);
			makeRectangle(i, j, x, y);
			run("Duplicate...", "duplicate");
			rename("move");
			run("Subtract Background...", "rolling=50 stack");
			run("8-bit");
			run("Auto Local Threshold", "method=Phansalkar radius=15 parameter_1=0 parameter_2=0 white stack");
			run("Select All");
			roiManager("Add");
			roiManager("Select", 0);
			run("Set Measurements...", "mean centroid area_fraction stack limit redirect=None decimal=8");
			roiManager("Multi Measure");
			rate_array=Table.getColumn("%Area1");
			close("move");
			close("Results");
			close("Roi Manager");
			n=0;
			for (m = 0; m < rate_array.length; m++){
				print("rate="+rate_array[m]);
				if (rate_array[m] > fraction_area ){  n=n+1; }
			}
			print(n);
			if (n >= fraction_number ){
				selectWindow(img);
				makeRectangle(i, j, x, y);
				run("Make Montage...", "columns="+column+" rows="+row+" scale=1");
				exit;
			}
		}
	}
	exit("没有合适的区域");
}

path="//10.10.42.178/DuLabSMB/14_临时上传文件--未知文件移至这里/to_CTL/translocation/20220621_translocation/20220621-dark-p2__2022-06-21T19_02_05-Measurement 1/Images/final.tiff";
print(path);
montage(path,100,100,1,1,50,20,55,6,10)
