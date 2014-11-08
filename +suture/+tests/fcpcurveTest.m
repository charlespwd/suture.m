classdef fcpcurveTest < matlab.unittest.TestCase
  methods (Test)
    function testWorking(testCase)
      import suture.fcpcurve
      actual = fcpcurve(0, 0);
      expected = 0;
      testCase.verifyEqual(actual, expected);
    end
  end
end
