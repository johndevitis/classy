classdef parent < handle
%% classdef parentClass
% 
% 
% 
% author: john devitis
% create date: 28-Oct-2016 15:59:01

%% object properties
	properties
        name = 'john'
        child
	end

%% dependent properties
	properties (Dependent)
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = parent()
            % create instance of child and save to instance of class
            self.child = nested_classes.child();
		end

	%% ordinary methods

	%% dependent methods

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
