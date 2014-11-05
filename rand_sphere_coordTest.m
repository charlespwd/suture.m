classdef rand_sphere_coordTest < matlab.unittest.TestCase
  methods (Test)
     function testSanityCheck(testCase)
       sumsqr = @(x) sum(x .* x);
       radius = 1;
       actual = radius;
       for D = 1:20
         testCase.verifyEqual(actual, sumsqr(rand_sphere_coord(1, D)), 'AbsTol', eps);
       end
     end
  end
end
