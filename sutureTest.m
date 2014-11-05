classdef sutureTest < matlab.unittest.TestCase
  methods (Test)
    function test0Case(testCase)
      A = 0;
      B = 0;
      testCase.verifyEqual(suture(A, B, 0), 0);
    end

    function test0CaseTwo(testCase)
      A = 0;
      B = 0;
      testCase.verifyEqual(suture(A, B, 0.5), 0.5);
    end

    function test11case(testCase)
      A = [1, 1];
      B = [1, 1];
      actual = arrayfun(@(t) suture(A, B, t), 0:2);
      expected = [0.0000 + 2.0000i   0.1585 + 1.5403i   1.0907 + 0.5839i];
      testCase.verifyEqual(actual, expected, 'AbsTol', 0.0001);
    end

    function testShouldWorkWithArrayT(testCase)
      A = [1, 1];
      B = [1, 1];
      actual = suture(A, B, 0:2);
      expected = [0.0000 + 2.0000i   0.1585 + 1.5403i   1.0907 + 0.5839i];
      testCase.verifyEqual(actual, expected, 'AbsTol', 0.0001);
    end

    function testShouldThrowIfAAndBDontHaveTheSameLength(testCase)
      A = [1, 1];
      B = [1, 1, 1];
      testCase.verifyError(@() suture(A, B, 0:2), 'suture:dimensions');
    end
  end
end
