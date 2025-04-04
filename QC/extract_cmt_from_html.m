function extract_cmt_from_html(filename, output_dir)
M=zeros(6);

finfo = dir(filename);
if (finfo.bytes < 100)					% Delete the file anyway because it exists but is empty
    warndlg('Failed to download the CMT file.','Warning')
	builtin('delete',filename);
    return
end

fid = fopen(filename,'r');

fid_cmt = fopen(fullfile(output_dir, "/CMTSOLUTION"),'w');
	for k = 1:23					% Jump first 24 html related lines
		lix = fgets(fid);
    end

    for k = 24:36
        lix = fgets(fid);
        fprintf(fid_cmt,'%s',lix);
    end
end