classdef ftmemoTest < matlab.unittest.TestCase
  methods (Test)
    function testShouldBeACircle(testCase)
      memo = 0;
      fn = '_ftmemotest.db';
      z = @(t) sin(t) + 1i*cos(t) -1i;
      dt = 3;
      t_interval = 0:dt:(2*pi+dt);
      Z = arrayfun(@(t) z(t), t_interval);
      testCase.verifyEqual(ftmemo(FourierTerms(0, 0), false, memo, fn, dt), Z, 'AbsTol', 0.01);
      testCase.verifyEqual(ftmemo(FourierTerms(0, 0), false, memo, fn, dt), Z, 'AbsTol', 0.01);
      delete(fn)
    end

    function testSerializerDeserializer(testCase)
      serializer = @(x) [real(x) imag(x)];
      deserializer = @(x) x(1:length(x)/2) + 1i*x(length(x)/2+1:length(x));
      z = @(t) sin(t) + 1i*cos(t) -1i;
      dt = 1;
      t_interval = 0:dt:(2*pi+dt);
      Z = arrayfun(@(t) z(t), t_interval);
      Zp = deserializer(serializer(Z));
      testCase.verifyEqual(Zp, Z);
    end

    function testForceUpdate(testCase)
      fn = '_ftmemotest.db';
      t_interval = @(dt) 0:dt:(2*pi+dt);
      z = @(t) sin(t) + 1i*cos(t) -1i;
      memo = 0;

      dt = 3;
      [~,    memo] = ftmemo(FourierTerms(0, 1), true, memo, fn, dt);
      [~,    memo] = ftmemo(FourierTerms(0, 2), true, memo, fn, dt);
      [Zact1, memo] = ftmemo(FourierTerms(0, 0), true, memo, fn, dt);

      Zexp1 = arrayfun(@(t) z(t), t_interval(dt));
      testCase.verifyEqual(Zact1, Zexp1, 'AbsTol', 0.01);

      dt = 2*pi;
      [Zact, ~] = ftmemo(FourierTerms(0, 0), true, memo, fn, dt);
      Zexp = arrayfun(@(t) z(t), t_interval(dt));
      % testCase.verifyNotEqual(Zact, Zact1, 'AbsTol', 0.01);
      testCase.verifyEqual(Zact, Zexp, 'AbsTol', 0.01);

      delete(fn)
    end
  end
end
