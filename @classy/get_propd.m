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
    [name, desc] = self.parse_props(enterflag,exitflag,contents);
    % save name/value pair to object property structure
    self.propd.name = [name{:}]; 
    self.propd.desc = [desc{:}];
end