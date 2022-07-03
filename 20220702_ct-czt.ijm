fa_path = getDirectory("Choose the Input Directory");

fa_file_list=getFileList(fa_path);	
for (l = 0; l < fa_file_list.length; l++){
	open(fa_path+fa_file_list[l]+"/Images/ch1.tiff");
	open(fa_path+fa_file_list[l]+"/Images/ch2.tiff");
	open(fa_path+fa_file_list[l]+"/Images/ch3.tiff");
	run("Concatenate...", "keep image1=ch1.tiff image2=ch2.tiff image3=ch3.tiff");
	run("Stack to Hyperstack...", "order=xyctz channels=3 slices=3 frames=60 display=Color");
	rename("final");
	saveAs("tiff", fa_path+fa_file_list[l]+"/Images//final.tiff");
	close("*");
	
}
