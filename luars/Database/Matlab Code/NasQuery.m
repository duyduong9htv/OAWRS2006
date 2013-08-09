function nas = NasQuery(varargin)

nasQuery = Queries.NasQuery();
for ii = 1:length(varargin)
    
    if ischar(varargin{ii})
        switch lower(varargin{ii})
            case 'ping'
                value = varargin{ii + 1};
                if isnumeric(value)
                    if length(value) == 1
                        nasQuery.byPing(value);
                    end
                end
        end
    end
end

nasObjects = nasQuery.getNas();
nasObjects = nasObjects.toArray();

if isempty(nasObjects)
    nas = [];
else
    nas = CreateNasStruct(nasObjects);
end


