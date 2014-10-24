import matlab.unittest.TestSuite;
clear suiteFolder
clear result
suiteFolder = TestSuite.fromFolder(pwd);
result = run(suiteFolder)
