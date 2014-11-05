import matlab.unittest.TestSuite;
import suture.*;
clear suitePackage
clear result
suitePackage = TestSuite.fromPackage('suture','IncludingSubpackages',true);
result = run(suitePackage)
