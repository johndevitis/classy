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
    if mkfolder && isempty(regexp(self.path,'@'))      
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
    fprintf(fid,'%% create date: %s\n\n', char(datetime));
    % properties
    fprintf(fid,'%%%% object properties\n');
    fprintf(fid,'\tproperties\n\tend\n\n');
    fprintf(fid,'%%%% dependent properties\n');
    fprintf(fid,'\tproperties (Dependent)\n\tend\n\n');            
    fprintf(fid,'%%%% private properties\n');
    fprintf(fid,'\tproperties (Access = private)\n\tend\n\n');
    % methods
    fprintf(fid,'%%%% dynamic methods\n');
    fprintf(fid,'\tmethods\n');
    fprintf(fid,'\t%%%% constructor\n');
    fprintf(fid,'\t\tfunction self = %s()\n\t\tend\n\n',self.name);
    fprintf(fid,'\t%%%% dependent methods\n\n');
    fprintf(fid,'\tend\n\n');
    fprintf(fid,'%%%% static methods\n');
    fprintf(fid,'\tmethods (Static)\n\tend\n\n');
    fprintf(fid,'%%%% protected methods\n');
    fprintf(fid,'\tmethods (Access = protected)\n\tend\n\n');
    % finish
    fprintf(fid,'end\n');
    % close file
    fclose(fid);            
end       