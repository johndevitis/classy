function write_propd(self,cname)
%% write_propd(self,cname) - write dependent function template 
%
% generate boiler plate syntax for dependent properties of classdef
% files. optional input of internal class reference name (default
% cname = 'self')
%
% classy uses 'self' as the default internal class reference but
% this can be changed using:
%
%  classy.write_propd('new_internal_name')
% 
% file assumes: 
%
% * %% dependent is located in the file to find the 
% name/description pairs of object properties and commented 
% descriptions. 
% * %% dependent methods is located in the file as its used as the 
% enter flag to start writing the classdef's dependent properties
%          
    if nargin < 2, cname = 'self'; end % check for null cname entry 
    % get/refresh dependent property name/value pairs
    self.get_propd();             
    % get file contents
    contents = self.read();

    % find where to write new content
    % define literal flag to start write
    enterflag = '%% dependent methods';        
    
    % loop to find enterflag in contents -> start line number
    ind = [];
    for ii = 1:length(contents)
        chk = strfind(contents{ii},enterflag);
        % if found, save current line number
        if ~isempty(chk)
            ind = ii;
        end                                                    
    end

    % error screen flag not found 
    %  note: w/o this classy will overwrite entire file w/ fcn
    %  calls
    if isempty(ind)
        fprintf('parse enterflag not found \n');
        return 
    end 

    % build content to write
    fprintf('Building the damn things... \n'); 
    % preallocate function strings to insert into file contents
    % 6 lines (per function) x number of functions to write  
    newContents = cell(5,length(self.propd.name));

    % loop properties to build strings
    for ii = 1:length(self.propd.name)
        % add blank line before fcn
        newContents{1,ii} = '';
        
        % fcn header
        newContents{2,ii} = sprintf('\t\tfunction %s = get.%s(%s)',...
            self.propd.name{ii},self.propd.name{ii},cname);
        
        % object property description as fcn documentation
        newContents{3,ii} = sprintf('\t\t%%%% %s',self.propd.desc{ii});  
        
        % add blank space for writings thangs
        newContents{4,ii} = sprintf('\t\t\t');
        
        % finish w/ end
        newContents{5,ii} = sprintf('\t\tend');
    end

    % insert newContent into existing content
    aa = contents(1:ind);       % before enterflag
    bb = newContents(:);        % generated function strings
    cc = contents(ind+1:end);   % after enterflag
    allContent = [aa;bb;cc];

    % write file to disk
    fprintf('Writing the damn things... \n');
    % open file for writing 
    % this will overwrite the file but it is  necessary and the 
    % previous contents were found before and will be re-written
    fid = self.open('w');
    fprintf(fid,'%s\n',allContent{:});
    fprintf('Done.\n');
    fclose(fid);
end