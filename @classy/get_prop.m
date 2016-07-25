function get_prop(self)
%% self.get_prop() 
%
% reads <classname>.m file and grabs property variable
% names paired with the adjacent comment discription. this is a 
% helper file to automate documentation files. the fcn uses the 
% classy.read() function for some automated error screening (this 
% might be removed in the future) and the parse_props utility 
% function to parse name/value pairs of standard object properties
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
    enterflag = 'properties'; exitflag = 'end';
    % mine file for contents
    [name, desc] = self.parse_props(enterflag,exitflag,contents);
    % save name/value pair to object property structure
    self.prop.name = [name{:}];
    self.prop.desc = [desc{:}];
end