classdef rand_sphere_coordTest < matlab.unittest.TestCase
  methods (Test)
     function testSanityCheck(testCase)
       import suture.rand_sphere_coord;
       sumsqr = @(x) sum(x .* x);
       radius = 2;
       actual = radius^2;
       for D = 1:20
         testCase.verifyEqual(actual, sumsqr(rand_sphere_coord(radius, D)), 'AbsTol', 10*eps);
       end
     end
  end
end
