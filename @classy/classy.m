classdef classy < file
%% classy 
%
% classy() is a utility class used for automated generation and 
% documentation of classdefs. 
%
% * optional input fullpath to assign path, name, and extension on create
%
% author: jdv 
% create date: 23-April-2016

%% properties
    properties
        author  % author of class
        prop    % class properties
        propd   % class properties (dependent)
        version = '0.1.2'
    end
    
%% dependent properties
    properties (Dependent)
 
    end
    
%% developer properties
    properties (Access = private)

    end
    
%% dynamic methods 
    methods
        
    %% constructor
        function self = classy(fullpath)
            if nargin < 1       % error screen empty input
                fullpath = [];  % empty fullpath input (handled in @file)
            end            
            % call file superclass constructor
            self@file(fullpath);            
            % ensure class extension is for m-file
            self.ext = '.m';
        end


    %% dependent methods

    end
    
%% static methods 
    methods (Static) 
        [name,desc] = parse_props(enterflag,exitflag,contents)
    end
    
%% private methods
    methods (Access = private)
              
    end    
end
