classdef fcpcurveTest < matlab.unittest.TestCase
  methods (Test)
    function testWorking(testCase)
      import suture.fcpcurve
      actual = fcpcurve(0, 0);
      expected = complex(0);
      testCase.verifyEqual(actual, expected);
    end

    function testBoundaryConditions(testCase)
      import suture.fcpcurve
      actual = fcpcurve(1, [0 2*pi]);
      expected = complex([0, 0]);
      testCase.verifyEqual(imag(actual), imag(expected), 'AbsTol', eps);
    end

    function testSimpleCase(testCase)
      import suture.fcpcurve
      actual = fcpcurve(1, 0:2);
      expected = [0.0000 + 0.0000i,  0.8687 + 0.4306i,  1.4447 + 1.2471i];
      testCase.verifyEqual(actual, expected, 'AbsTol', 0.001);
    end
  end
end
