classdef Memo
  % MEMO  A way to memoize expensive computations using a flat file as storage
  %
  %   memo = Memo(filename, f, hasher, serializer, deserializer)
  %    filename:  the filename(!)
  %    f: <X> -> <T>,  the expensive function f(x). It takes a single input of type <X> and returns
  %      something of type <T>
  %    hasher: <X> -> String.  It takes the input to f and transforms it into a
  %      unique hash of type string.
  %        e.g. f(x) = x^2 , hasher = @(x) num2str(abs(x)).
  %        You're smart, you can figure out this has cool/clever properties.
  %    serializer: <T> -> R^k, k > 0.  It turns the result of f(x) into a real valued array.
  %    deserializer: R^k -> <T>,  takes a serialized f and puts it back into a <T>.
  %
  %  The serializer must be such that (deserializer (serializer x)) == x
  %
  %  ### EXAMPLE
  %   Take f = @(g) integral(@(x) g(x), -1000:0.1:1000);
  %   I want to know the result of integrating from -1000:1000 some real-valued functions
  %   My type <X> is a function that I wish to integrate
  %   My type <T> is a scalar
  %   A possible hashing function is simply @func2str
  %   My serializer/deserializer combo can be the identity because the result is already in R^k
  %
  %     memo = Memo('integralsdatabase.db', f, @func2str, @(x) x, @(x) x);
  %     memo.read(@(x) sin(x)) % long, first run
  %     memo.read(@(x) sin(x)) % instantaneous, bigO(1)
  %
  %   Since the results are saved in a file, they can be recovered, shared, and more(!).
  properties
    filename,
    func,
    hasher,
    serializer,
    deserializer,
    store, % the memoization table, a hashmap
  end

  methods
    function memo = Memo(filename, func, hasher, serializer, deserializer)
      memo.filename = filename;
      memo.func = func;
      memo.hasher = hasher;
      memo.serializer = serializer;
      memo.deserializer = deserializer;

      % initialize the memoization store
      fileid = fopen(filename);
      if (fileid ~= -1) % file exists
        [hashes, values] = memo.parsefile(fileid);
        memo.store = containers.Map(hashes, values);
        fclose(fileid);
      else
        memo.store = containers.Map;
      end
    end

    % What's going on below is unclear, so I feel inclined to give you some
    % details on how it works.
    % It parses the data in the file, line by line, following this format:
    %  - Whatever is in quotes is the key
    %  - Whatever follows a `",` is the value, could be anything, as long as
    %  serializer returns an array-like value. (array or number)
    function [hashes, values] = parsefile(memo, fileid)
      % PARSEFILE  parses the file into a set of hashes and values
      l = fgetl(fileid);
      i = 1;
      while ischar(l)
        mlines{i} = l;
        i = i + 1;
        l = fgetl(fileid);
      end
      hashes = cellfun(@(l) regexp(l, '"(.*)"', 'tokens'), mlines);
      hashes = cellfun(@(m) m{1}, hashes, 'UniformOutput', false);
      values = cellfun(@(l) regexp(l, '",(.*)', 'tokens'), mlines);
      values = cellfun(@(m) m{1}, values, 'UniformOutput', false);
      values = cellfun(@(m) eval(['[', m, ']']), values, 'UniformOutput', false);
      values = cellfun(@(m) memo.deserializer(m), values, 'UniformOutput', false);
    end

    function value = read(memo, x)
      % READ  read a value from the memoization table, or enter a value in it
      hash = memo.hasher(x);
      if memo.store.isKey(hash)
        value = memo.deserializer(memo.store(hash));
        if length(value) > 1
          value = value(1:find(value, 1, 'last')); % trick to strip 0's from the end of the vector
        end
      else
        value = memo.func(x);
        memo.store(hash) = memo.serializer(value);
        memo.write(hash, value);
      end
    end

    function remove = remove(memo, x)
      % REMOVE  remove a keyvalue pair from the file
      %
      % Careful, not optimized whatsoever.
      hash = memo.hasher(x);
      if memo.store.isKey(hash)
        memo.store.remove(hash);
        memo.writeAll()
      end
    end

    function writeAll(memo)
      % WRITEALL  clear the file and rewrite all key value pairs
      fid = fopen(memo.filename, 'w');
      hashes = memo.store.keys;
      c2map = @(x) cellfun(@(c) c', x)';
      values = memo.store.values;
      values = c2map(values);
      for i = 1:size(values, 1)
        hash = hashes{i};
        value = values(i, :);
        memo.write(hash, value, fid);
      end
      fclose(fid);
    end

    function write(memo, hash, value, fid)
      % WRITE  Write one hash/value pair to the file
      %
      %  optionally write to the fid passed,
      %  open file in append mode by default
      closeit = false;
      if nargin < 4
        fid = fopen(memo.filename, 'a');
        closeit = true;
      end
      fprintf(fid, '"%s"', hash);
      serialized = memo.serializer(value);
      for i = 1:length(serialized)
       fprintf(fid, ',%g', serialized(i));
      end
      fprintf(fid, '\n');
      if closeit
        fclose(fid);
      end
    end
  end
end