classdef MemoTest < matlab.unittest.TestCase
  methods (Test)
    function testInitFromEmptyFile(testCase)
      filename = 'fakenonexistingdb.db';
      warning('off', 'MATLAB:DELETE:FileNotFound');
      delete(filename);
      warning('on', 'MATLAB:DELETE:FileNotFound');
      f = @(x) x^2;
      hasher = @(x) x*2;
      serializer = @(x) x*2;
      deserializer = @(x) x/2;

      memo = Memo(filename, f, hasher, serializer, deserializer);

      testCase.verifyEqual(filename     ,  memo.filename);
      testCase.verifyEqual(f            ,  memo.func);
      testCase.verifyEqual(hasher   ,  memo.hasher);
      testCase.verifyEqual(deserializer ,  memo.deserializer);
      testCase.verifyEqual(0            ,  memo.store.length);
    end

    function testInitFromNonEmptyFile(testCase)
      filename = '_testdb.db';
      f = @(x) x^2;
      hasher = @(x) x*2;
      serializer = @(x) x*2;
      deserializer = @(x) x/2;

      memo = Memo(filename, f, hasher, serializer, deserializer);

      testCase.verifyEqual(filename     ,  memo.filename);
      testCase.verifyEqual(f            ,  memo.func);
      testCase.verifyEqual(hasher   ,  memo.hasher);
      testCase.verifyEqual(deserializer ,  memo.deserializer);
      testCase.verifyEqual(2            ,  memo.store.length);
    end

    function testReadingFromTheStoreWhenItsInTheStore(testCase)
      filename = '_testdb.db';
      f = @(x) x + 10;
      hasher = @(x) num2str(x);
      serializer = @(x) x;
      deserializer = @(x) x;

      memo = Memo(filename, f, hasher, serializer, deserializer);

      testCase.verifyEqual(22            ,  memo.read(12));
    end

    function testReadingFromTheStoreWhenItsNotInTheStore(testCase)
      filename = '_testdb.db';
      f = @(x) x + 10;
      hasher = @(x) num2str(x);
      serializer = @(x) x;
      deserializer = @(x) x;

      memo = Memo(filename, f, hasher, serializer, deserializer);
      memo.remove(100);

      testCase.verifyEqual(110            ,  memo.read(100));
      memo.remove(100);
    end

    function testWithComplicatedSerializerAndOutput(testCase)
      filename = '_trashshit.db';
      warning('off', 'MATLAB:DELETE:FileNotFound');
      delete(filename);
      warning('on', 'MATLAB:DELETE:FileNotFound');

      f = @(x) [x, 1*i*x, x+x];
      hasher = @(x) ['xxx' num2str(x)];
      serializer = @(x) [real(x) imag(x)];
      deserializer = @(x) x(1:length(x)/2) + 1*i*x(length(x)/2+1:length(x));

      memo = Memo(filename, f, hasher, serializer, deserializer);
      testCase.verifyEqual([2, 2*i, 4], memo.read(2));
      testCase.verifyEqual([2, 2*i, 4], memo.read(2));

      delete(filename);
    end

    function testWithComplicatedHasher(testCase)
      filename = '_trashshit.db';
      warning('off', 'MATLAB:DELETE:FileNotFound');
      delete(filename);
      warning('on', 'MATLAB:DELETE:FileNotFound');

      f = @(x) [x.left x.right];
      hasher = @(x) ['"{' num2str(x.left), ',' num2str(x.right) '}"'];
      serializer = @(x) x;
      deserializer = @(x) x;

      memo = Memo(filename, f, hasher, serializer, deserializer);
      testInput.left = [1, 2];
      testInput.right = [3, 4];
      testCase.verifyEqual([1,2,3,4], memo.read(testInput));
      testCase.verifyEqual([1,2,3,4], memo.read(testInput));

      delete(filename);
    end
  end
end
