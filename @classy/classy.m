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
        [name,desc] = parse_props(enterflag,exitflag,contents)
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
