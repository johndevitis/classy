classdef classy < matlab.mixin.SetGet
%% classy 
% classy() is a utility class used for automated generation and 
% documentation of classdefs. 
%
% * optional input fullpath to assign path, name, and extension on create
%
% author: jdv 
% create date: 23-April-2016

%% properties
    properties
        path = 'C:\Temp' % root path  
        name = 'foo'     % class name 
        ext = 'm'        % matlab ext
        author           % author of class
        prop             % class properties
        propd            % class properties (dependent)
    end
    
%% dependent properties
    properties (Dependent)
        fullname        % full file path/name.ext generated 
    end
    
%% developer properties
    properties (Access = private)

    end
    
%% dynamic methods 
    methods
        %% constructor
        function self = classy(fullpath)
            if nargin > 0
                [self.path,self.name,self.ext] = fileparts(fullpath);
                if isempty(self.ext)
                    self.ext = '.m';
                end
            end
        end        
                

        function get_propd(self)
        %% get_propd - get dependent class properties
        %
        % this is the sister function to get_prop() that reads the dependent
        % object properties and saves name/value pairs. see get_prop() help
        % for more description.  
        %
        %   classdef classname
        %   properties        <- write flag
        %     var1 % desc1    <- this works
        %     var2 %desc2     <- this also works
        %     var3%desc3      <- this also also works
        %   end               <- exitflag
        %
        %   output
        %   var  = {'var1', 'var2'} 
        %   desc = {'desc1','desc2'}
        %
            contents = self.read(); % read file contents
            % set flags
            enterflag = 'properties (Dependent)'; exitflag = 'end';
            % mine file for contents
            [name, desc] = parse_props(enterflag,exitflag,contents);
            % save name/value pair to object property structure
            self.propd.name = [name{:}]; 
            self.propd.desc = [desc{:}];
        end
        
        function get_prop(self)
        %% self.get_prop() reads <classname>.m file and grabs property variable
        % names paired with the adjacent comment discription. this is a 
        % helper file to automate documentation files. the fcn uses the 
        % classy.read() function for some automated error screening (this 
        % might be removed in the future) and the parse_props utility 
        % function to parse name/value pairs of standard object properties
        %
        % classdef classname
        % properties        <- write flag
        %   var1 % desc1    <- this works
        %   var2 %desc2     <- this also works
        %   var3%desc3      <- this also also works
        % end               <- exitflag
        %
        % output -> var  = {'var1', 'var2'} 
        %           desc = {'desc1','desc2'}
        %
            contents = self.read(); % read file contents
            % set flags
            enterflag = 'properties'; exitflag = 'end';
            % mine file for contents
            [name, desc] = parse_props(enterflag,exitflag,contents);
            % save name/value pair to object property structure
            self.prop.name = [name{:}];
            self.prop.desc = [desc{:}];
        end
        
        function contents = read(self)              
        %% read() - read any ascii file line by line
        % each line is saved as a row in cell array
            self.chk_name();
            fid = self.open();
            % loop till end of file or flag
            contents = []; cnt = 1;
            while ~feof(fid)
                % read line
                contents{cnt,1} = fgetl(fid);
                cnt = cnt+1;
            end
            % close file & report status
            status = fclose(fid);
            if status == 0; fprintf('Read successful. \n');
            else fprintf('Not successful. Damn. \n');
            end
        end
        
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
            fid = fopen(self.fullname,'a');
            % ---- write contents ----
            % header
            fprintf(fid,'classdef %s < matlab.mixin.SetGet\n', self.name);
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
        
    %% dependent methods
        function fullname = get.fullname(self)
        % get full file name based on path, name, and ext.
        % error screen '.txt' 'txt' possibility
            if self.ext(1) == '.'
                fullname = fullfile(self.path,[self.name self.ext]);
            else
                fullname = fullfile(self.path,[self.name '.' self.ext]);
            end
        end
    end
    
%% static methods 
    methods (Static) 
    end
    
%% private methods
    methods (Access = private)
        
        function chk_name(self)
        %% check_name()
        % error screen null name entry
            if isempty(self.name)
                error('Name that thang.')
            end
        end
        
        function fid = open(self,perm)
        %% open() - open file with error screening capability.
        % this function is meant to be a catch-all for catching errors (for
        % lack of a better word) and aid in scalability
        %
        % perm = optional permissions, defaults to read only -> perm = 'r';
        %
            if nargin < 2 % error screen null perm entry
                perm = 'r'; % default to read only
            end
            % open file with permissions
            [fid, errmsg] = fopen(self.fullname,perm);
            if ~isempty(errmsg)
                error(errmsg);
            end
        end        
    end    
end


%% utility functions 

function [name, desc] = parse_props(enterflag,exitflag,contents)
%% parse_props(enterflag,exitflag,contents) - parse class properties
% mine classdef property definitions by enter/exit flags and return
% name/value pairs
%
% Bug1: currently does not support empty name/description grouping. 
%   that is:
%       properties 
%           % this is a description w/ no name 
%       end
%   will not work
%
% Bug2: the inverse of bug1 is true - function requires comments (desc) to
% register a class property name
%
% Bug3: does not pick up two spaces between <name> % __ <desc>
% 
    writeflag = 0; 
    cnt = 0; % match counter
    txt=[];  % matched content
    for ii = 1:length(contents) % loop for flags
        % trim leading/trailing whitespace of line ii
        cont = strtrim(contents{ii});                
        % check start flag
        if strcmp(cont,enterflag)
            writeflag = 1; % flag for write
        end                
        % check exit flag
        if strcmp(cont,exitflag) && writeflag == 1
            % if previously writing and exitflag caught
            % then stop writing
            writeflag = 0; 
        end
        % check for write flag, do not write on first flag
        if writeflag == 1
            cnt = cnt+1;     % advance matched counter
            txt{cnt} = cont; % save matched content
        end                  
    end                      
    % REMOVE enter flag from matched text
    txt = txt(2:end);
    % separate variable name and descriptive comment 
    name = regexp(txt,'\w*(?=(.)?%(.)?)','match');
    desc = regexp(txt,'(?<=%(.)?)\w+.*$','match');
    % error screen null prop/desc entries
    if isempty(name) name = {''}; end
    if isempty(desc) desc = {''}; end
end
