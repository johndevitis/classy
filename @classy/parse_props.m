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
% Bug4: 10312016. new escape character: +
%
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
