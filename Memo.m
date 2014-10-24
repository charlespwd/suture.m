classdef Memo
  properties
    filename,
    func,
    hasher,
    serializer,
    deserializer,
    store,
  end

  methods
    function memo = Memo(filename, func, hasher, serializer, deserializer)
      memo.filename = filename;
      memo.func = func;
      memo.hasher = hasher;
      memo.serializer = serializer;
      memo.deserializer = deserializer;

      % initialize store
      fileid = fopen(filename);
      if (fileid ~= -1) % file exists
        l = fgetl(fileid);
        i = 1;
        while ischar(l)
          lines{i} = l;
          i = i + 1;
          l = fgetl(fileid);
        end
        hashes = cellfun(@(l) regexp(l, '"(.*)"', 'tokens'), lines);
        hashes = cellfun(@(m) m{1}, hashes, 'UniformOutput', false);
        values = cellfun(@(l) regexp(l, '",(.*)', 'tokens'), lines);
        values = cellfun(@(m) m{1}, values, 'UniformOutput', false);
        values = cellfun(@(m) eval(['[', m, ']']), values, 'UniformOutput', false);
        values = cellfun(@(m) deserializer(m), values, 'UniformOutput', false);
        memo.store = containers.Map(hashes, values);
        fclose(fileid);
      else
        memo.store = containers.Map;
      end
    end

    function value = read(memo, x)
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
      hash = memo.hasher(x);
      if memo.store.isKey(hash)
        memo.store.remove(hash);
        memo.writeAll()
      end
    end

    function writeAll(memo)
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
