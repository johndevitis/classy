classdef classy < matlab.mixin.SetGet
%% classy is a utility class used for automated generation and 
% documentation of classdefs
%
% author: jdv 
% create date: 04232016

    %% -- properties -- %%
    properties
        path = 'C:\Temp' % root path  
        name = 'foo'     % class name 
        ext = 'm'        % matlab ext
        prop             
        propd
    end
    
    %% -- dependent properties -- %%
    properties (Dependent)
        fullname
    end
    
    %% -- developer properties -- %%
    properties (Access = private)

    end
    
    %% -- dynamic methods -- %%
    methods
        %% -- constructor -- %%
        function obj = classy()
        end        
        
        function file = gen_doc(obj)
        % fcn 
        end
        
        function write_propd(obj,cname)
        % generate boiler plate syntax for dependent properties of classdef
        % files. optional input of internal class reference name (default
        % cname = 'obj')
        % 
        % file assumes: 
        %   %% -- dependent props -- %% is located in the file to find the
        %   name/description pairs of object properties and commented
        %   descriptions. 
        % 
        %   %% -- dependent methods -- %% is the enter flag to start
        %   writing the classdef's dependent properties
        %
        %   classy uses 'obj' as the default internal class reference          
            if nargin < 2 cname = 'obj'; end % check for null cname entry 
            % get/refresh dependent property name/value pairs
            obj.get_propd();             
            % get file contents
            contents = obj.read();
            
            % find where to write new content
            % define literal flag to start write
            enterflag = '%% -- dependent methods -- %%';             
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
            newContents = cell(5,length(obj.propd.name));
            % loop properties to build strings
            for ii = 1:length(obj.propd.name)
                % add blank line before fcn
                newContents{1,ii} = '';
                % fcn header
                newContents{2,ii} = sprintf('\t\tfunction %s = get.%s(%s)',...
                    obj.propd.name{ii},obj.propd.name{ii},cname);
                % object property description as fcn documentation
                newContents{3,ii} = sprintf('\t\t%% %s',obj.propd.desc{ii});    
                % add blank space for writings thangs
                newContents{4,ii} = '\t\t\t';
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
            fid = obj.open('w');
            fprintf(fid,'%s\n',allContent{:});
            fprintf('Done.\n');
            fclose(fid);
        end
        
        function get_propd(obj)
        % this is the sister function to get_prop() that reads the dependent
        % object properties and saves name/value pairs. see get_prop() help
        % for more description.  
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
            contents = obj.read(); % read file contents
            % set flags
            enterflag = 'properties (Dependent)'; exitflag = 'end';
            % mine file for contents
            [name, desc] = parse_props(enterflag,exitflag,contents);
            % save name/value pair to object property structure
            obj.propd.name = [name{:}]; 
            obj.propd.desc = [desc{:}];
        end
        
        function get_prop(obj)
        % obj.get_prop() reads <classname>.m file and grabs property variable
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
            contents = obj.read(); % read file contents
            % set flags
            enterflag = 'properties'; exitflag = 'end';
            % mine file for contents
            [name, desc] = parse_props(enterflag,exitflag,contents);
            % save name/value pair to object property structure
            obj.prop.name = [name{:}];
            obj.prop.desc = [desc{:}];
        end
        
        function contents = read(obj)              
        % read any ascii file line by line
        % each line is saved as a row in cell array
            obj.chk_name();
            fid = obj.open();
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
        
        function create_class(obj)
        % automate standard class generation 
        %   removes some boiler plate code 
        % notes:
        %   object file name used as class name
        %   class folder created in obj.path and obj.ext ignored     
        %   appends to end of file if exists
        
            % add @class folder
            obj.path = fullfile(obj.path,['@' obj.name]); 
            mkdir(obj.path);
            fprintf('Added class folder %s\n',obj.path)
            % create class.m file in @class folder
            fid = fopen(obj.fullname,'a');
            % ---- write contents ----
            % header
            fprintf(fid,'classdef %s\n', obj.name);
            fprintf(fid,'%%%% classdef %s\n', obj.name);
            fprintf(fid,'%% author: \n');
            fprintf(fid,'%% create date: %s\n\n', char(datetime));
            % properties
            fprintf(fid,'\t%%%% -- object properties -- %%%%\n');
            fprintf(fid,'\tproperties\n\tend\n\n');
            fprintf(fid,'\t%%%% -- dependent properties -- %%%%\n');
            fprintf(fid,'\tproperties (Dependent)\n\tend\n\n');            
            fprintf(fid,'\t%%%% -- developer properties -- %%%%\n');
            fprintf(fid,'\tproperties (Access = private)\n\tend\n\n');
            % methods
            fprintf(fid,'\t%%%% -- dynamic methods-- %%%%\n');
            fprintf(fid,'\tmethods\n');
            fprintf(fid,'\t\t%%%% -- constructor -- %%%%\n');
            fprintf(fid,'\t\tfunction obj = %s()\n\t\tend\n\n',obj.name);
            fprintf(fid,'\t\t%%%% -- dependent methods -- %%%%\n\n');
            fprintf(fid,'\tend\n\n');
            fprintf(fid,'\t%%%% -- static methods -- %%%%\n');
            fprintf(fid,'\tmethods (Static)\n\tend\n\n');
            fprintf(fid,'\t%%%% -- internal methods -- %%%%\n');
            fprintf(fid,'\tmethods (Access = private)\n\tend\n\n');
            % finish
            fprintf(fid,'end\n');
            % close file
            fclose(fid);            
        end       
        
        %% -- dependent methods -- %%
        function fullname = get.fullname(obj)
        % get full file name based on path, name, and ext.
        % error screen '.txt' 'txt' possibility
            if obj.ext(1) == '.'
                fullname = fullfile(obj.path,[obj.name obj.ext]);
            else
                fullname = fullfile(obj.path,[obj.name '.' obj.ext]);
            end
        end
    end
    
    %% -- static methods -- %%
    methods (Static) 
    end
    
    %% -- internal methods -- %%    
    methods (Access = private)
        
        function chk_name(obj)
        % error screen null name entry
            if isempty(obj.name)
                error('Name that thang.')
            end
        end
        
        function fid = open(obj,perm)
        % open file with error screening capability. 
        % this function is meant to be a catch-all for catching errors (for
        % lack of a better word) and aid in scalability
        % 
        % perm = optional permissions, defaults to read only
        %    
            if nargin < 2 % error screen null perm entry
                perm = 'r'; % default to read only
            end
            % open file with permissions
            [fid, errmsg] = fopen(obj.fullname,perm);
            if ~isempty(errmsg)
                error(errmsg);
            end
        end
        
    end
    
end

%% -- utility functions -- %%
function [name, desc] = parse_props(enterflag,exitflag,contents)
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

%%         function txt = parse_literals(obj,enterflag,exitflag)
%         % function accepts and enterflag and exit flag and returns all
%         % lines of text within the file inbetween
%             fid = obj.open();
%             % setup meta
%             flg = 0; cnt = 0; txt = [];
%             % loop for flags
%             while ~feof(fid) && flg == 0
%                 % read line
%                 tline = fgetl(fid);
%                 % search for literals
%                 ent = strfind(tline, enterflag);
%                 ext = strfind(tline, exitflag); 
%                 % check enter
%                 if ~isempty(ent)
%                     cnt = cnt+1;
%                 end
%                 % check exit
%                 if ~isempty(ext)
%                     flg = 1;
%                 end
%                 % check for save
%                 if cnt >= 1 && flg == 0
%                     % save line
%                     txt{cnt} = sprintf('%s',tline);
%                     % advance counter
%                     cnt = cnt+1
%                 end
%             end
%         end