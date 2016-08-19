%% Example 2 - Creating Multiple Classes
%
%
% 
% jdv 08192016

%% create first class in pwd named foobar
c = classy();
c.name = fullfile(pwd,'foobar.m');

c.fullname % note the path, name, and extention are handled

c.create()

%% now lets say you want to create another class in the same root folder 
% we first need to strip the previous class's class folder before we
% create. else, the new classdef created will be in the root of the
% previous classes folder (classy does not nest @ folders since its
% invalid matlab syntax, but for now you still need to manually strip the
% folder)
c.strip_folder();
c.name = 'fumanchu';
c.create();
