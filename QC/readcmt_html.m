function [M,text] = readcmt(filename)
M=zeros(6);

finfo = dir(filename);
if (finfo.bytes < 100)					% Delete the file anyway because it exists but is empty
    warndlg('Failed to download the CMT file.','Warning')
	builtin('delete',filename);
    return
end

fid = fopen(filename,'r');
	for k = 1:24					% Jump first 24 html related lines
		lix = fgets(fid);
	end

todos = fread(fid,'*char');		
fclose(fid);

if (todos(1) == '<')
	warndlg('Could not find any event with this parameters search.','Warning')
	builtin('delete',filename);
	return
end

ind = strfind(todos', '<hr>');			% Find first occurrence of one 'hline' and break it there
todos(ind(1):end) = [];
ind = strfind(todos', '</pre>');		% Now they invented plus this one
if (~isempty(ind))
	todos(ind(1):end) = [];
end

%name lat lon dep time_shift hdur mw expo xm[6]
array = strread(todos);
if(size(array(1))>1)
    warndlg("Caution, one more event exists")
end
text = string(["Lon" array(3) "Lat" array(2)]);
M = [array(1,9:14)];
end
