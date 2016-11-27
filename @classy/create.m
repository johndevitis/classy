function create(self,mkfolder)
%% create(mkfolder) - automate standard class generation 
% removes some boiler plate code 
%
% *notes:*
% 
% * mkfolder = 1 by default and will create @classname folder for
% the class. to turn this off, pass in a false boolean 
% * object file name used as class name
% * class folder created in self.path and self.ext ignored     
% * does not overwite - appends to end of file if exists

    % error screen null entry
    if nargin < 2       % chk number of inputs
        mkfolder = 1;   % default to making class folder
    end

    % check for mkfolder boolean AND check path for existing
    % @class folder
    if mkfolder && isempty(regexp(self.path,'@','once'))      
        self.path = fullfile(self.path,['@' self.name]);            
    end   

    % add @class folder
    [~,~,~] = mkdir(self.path); % suppress warnings
    fprintf('Added class to: %s\n',self.path)

    % create class.m file in @class folder
    fid = fopen(self.fullname,'a'); % append only
    
    % ---- write contents ----
    % header
    fprintf(fid,'classdef %s < handle\n', self.name);
    fprintf(fid,'%%%% classdef %s\n', self.name);
    fprintf(fid,'%% \n');
    fprintf(fid,'%% \n');
    fprintf(fid,'%% \n');
    fprintf(fid,'%% author: %s\n',self.author);
    fprintf(fid,'%% create date: %s\n', char(datetime));
    fprintf(fid,'%% classy version: %s\n\n',self.version);
    
    % properties
    fprintf(fid,'%%%% object properties\n');
    fprintf(fid,'\tproperties\n\tend\n\n');
    fprintf(fid,'%%%% dependent properties\n');
    fprintf(fid,'\tproperties (Dependent)\n\tend\n\n');            
    fprintf(fid,'%%%% private properties\n');
    fprintf(fid,'\tproperties (Access = private)\n\tend\n\n');
    
    % methods
    add_constructor(fid,self.name)
    add_method(fid,'ordinary');
    add_method(fid,'dependent');
    add_method(fid,'static');
    add_method(fid,'protected');

    % finish
    fprintf(fid,'end\n');

    % close file
    fclose(fid);            
end       

function add_constructor(fid,name)
    fprintf(fid,'%%%% constructor\n');
    fprintf(fid,'\tmethods\n');
    fprintf(fid,'\t\tfunction self = %s()\n\t\tend\n',name);
    fprintf(fid,'\tend\n\n');
end

function add_method(fid,name)
    switch name
        case 'static'
            value = '(Static)';
        case 'protected'
            value = '(Access = protected)';
        otherwise
            value = '';
    end
    fprintf(fid,'%%%% %s methods\n',name);
    fprintf(fid,'\tmethods %s\n\tend%s\n\n',value,sprintf(' %% /%s',name));
end
