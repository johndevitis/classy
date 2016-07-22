function strip_folder(self)
% remove @class_name from object path if present
% note - updates instance of self.path only
    ind = regexp(self.path,'@','once');  % find location of @ folder
    if ~isempty(ind) % if present, remove
        self.path = self.path(1:ind-1);                
    end
end