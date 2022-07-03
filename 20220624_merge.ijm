fa_path = getDirectory("Choose the Input Directory");

fa_file_list=getFileList(fa_path);	
for (l = 0; l < fa_file_list.length; l++){
	sonpath=fa_path+fa_file_list[l]+"/Images";
	son_list=getFileList(sonpath);	
	print(son_list.length);
	open(fa_path+fa_file_list[l]+"/Images//"+"r02c02f0"+1+"p01.tif");
	rename("fix");
	for (i = 2; i < 8; i++){
		for (j = 2; j < 12; j++){
			if (j<10) {
				p="0"+j;
			}
			else {
				p=j;
			}
			name="r0"+i+"c"+p+"f01p01"+".tif";
			print(name);
			open(fa_path+fa_file_list[l]+"/Images//"+name);
			rename("move");
			run("Concatenate...", "open image1=fix image2=move");
			rename("fix");
			
		}
	}
	selectWindow("fix");
	getDimensions(width, height, channels, slices, frames);
	run("Duplicate...", "duplicate frames=2-"+frames);
	saveAs("tiff",fa_path+fa_file_list[l]+"/Images//ch1.tiff");
	close("*");
}

