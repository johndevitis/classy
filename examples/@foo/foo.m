classdef foo < matlab.mixin.SetGet
%% classdef foo
% 
% 
% 
% author: jdv
% create date: 25-Jul-2016 00:46:18

%% object properties
	properties
		prop1 % this is prop1
		prop2 %this is prop 2
	end

%% dependent properties
	properties (Dependent)
		prop3 % this is dependent prop3
		prop4 %this is dependent prop4
	end

%% private properties
	properties (Access = private)
	end

%% dynamic methods
	methods
	%% constructor
		function self = foo()
		end

	%% dependent methods

		function prop3 = get.prop3(self)
		%% this is dependent prop3
			
		end

		function prop4 = get.prop4(self)
		%% this is dependent prop4
			
        end

	end

%% static methods
	methods (Static)
	end

%% protected methods
	methods (Access = protected)
	end

end
