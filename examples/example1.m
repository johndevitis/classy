%% classy example1
%
% this script shows some of classy's functionality as well as some tests to
% be run after changing [any] of the code 
%
% author: jdv
% create date: 04232016

%% create a default class template

% instantiate class
c = classy();
 
% use default name (foo) and destination folder (C:\Temp)
c.create();

% open class in matlab editor
edit(c.fullname);


%% read contents of class
contents = c.read()


%% write dependent properties and descriptions to dependent methods section
%   note: this requires manual addition of properties and commented
%   descriptions 
c.write_propd();