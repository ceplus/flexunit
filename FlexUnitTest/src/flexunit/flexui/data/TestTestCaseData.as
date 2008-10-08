/*
   Copyright (c) 2008. Adobe Systems Incorporated.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

     * Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.
     * Neither the name of Adobe Systems Incorporated nor the names of its
       contributors may be used to endorse or promote products derived from this
       software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
*/
package flexunit.flexui.data
{
   import flexunit.flexui.data.filter.AllTestFunctionStatus;
   import flexunit.flexui.data.filter.EmptyTestFunctionStatus;
   import flexunit.flexui.data.filter.ErrorTestFunctionStatus;
   import flexunit.flexui.data.filter.TestfFunctionStatuses;
   import flexunit.framework.TestCase;

   public class TestTestCaseData extends TestCase
   {
      private var testCase : TestFunctionRowData = new TestFunctionRowData();
      private var model : TestCaseData = new TestCaseData( testCase );
      
      public function testAddTest() : void
      {
         testCase.testSuccessful = true;

         model.addTest( testCase );
         
         assertEquals(
            "testCase.parentTestCaseSummary is not correctly set",
            model,
            testCase.parentTestCaseSummary );
         
         assertTrue(
            "model.testSuccessful should be true since no tests failed",
            model.testSuccessful );
         
         assertEquals(
            "model.testsNumber should be one since only one test run",
            1,
            model.testsNumber );

         assertEquals(
            "model.passedTestsNumber should be one since only one test passed",
            1,
            model.passedTestsNumber );

         testCase.testSuccessful = false;

         model.addTest( testCase );

         assertEquals(
            "testCase.parentTestCaseSummary is not correctly set",
            model,
            testCase.parentTestCaseSummary );
         
         assertFalse(
            "model.testSuccessful should be false since one tests failed",
            model.testSuccessful );
         
         assertEquals(
            "model.testsNumber should be one since only two tests run",
            2,
            model.testsNumber );

         assertEquals(
            "model.passedTestsNumber should be one since only one test passed",
            1,
            model.passedTestsNumber );
      }
      
      public function testRefresh() : void
      {
         for ( var i : int = 1; i < 13; i++ )
         {
            if ( i % 2 == 0 )
            {
               model.testFunctions.addItem( generateTestCaseRowData( "testCase" + i, "1", "1", i % 3 ) );
            }
            else
            {
               model.testFunctions.addItem( generateTestCaseRowData( "testCase" + i, "1", "2", i  % 3 ) );
            }
         }
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 12 " + 
            "(no filter applied)",
            12,
            model.testFunctions.length );
         
         model.selectedTestFunctionStatus = TestfFunctionStatuses.ERRORS_AND_FAILURES;         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 6 " + 
            "(selectedTestCaseStatus = ErrorTestCaseStatus applied)",
            6,
            model.testFunctions.length );

         model.selectedTestFunctionStatus = TestfFunctionStatuses.ALL;
         model.filterText = "testCase1"         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 4 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'testCase1' applied)",
            4,
            model.testFunctions.length );

         model.filterText = "TESTCASE1"         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 4 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'TESTCASE1' applied)",
            4,
            model.testFunctions.length );

         model.selectedTestFunctionStatus = TestfFunctionStatuses.ERRORS_AND_FAILURES; 
         model.filterText = "SE1"         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 2 " + 
            "(selectedTestCaseStatus = ErrorTestCaseStatus and filterText = 'SE1' applied)",
            2,
            model.testFunctions.length );
         
         model.selectedTestFunctionStatus = TestfFunctionStatuses.ERRORS_AND_FAILURES; 
         model.filterText = "";         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 6 " + 
            "(selectedTestCaseStatus = ErrorTestCaseStatus and filterText = '' applied )",
            6,
            model.testFunctions.length );

         model.selectedTestFunctionStatus = TestfFunctionStatuses.EMPTY; 
         model.filterText = "";
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 4 " + 
            "(selectedTestCaseStatus = EmptyTestCaseStatus and filterText = '' applied)",
            4,
            model.testFunctions.length );

         model.selectedTestFunctionStatus = TestfFunctionStatuses.ALL; 
         model.filterText = "SE1";         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 4 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'SE1' applied)",
            4,
            model.testFunctions.length );
         
         model.qualifiedClassName = "com.adobe.test::TestUltimateModel";
         model.filterText = "Ulti";
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 12 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'Ulti' applied) because the filter match the test case name",
            12,
            model.testFunctions.length );

         model.filterText = "ulti";
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 12 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'Ulti' applied) because the filter match the test case name",
            12,
            model.testFunctions.length );

         model.filterText = "testu";
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 12 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = 'testu' applied) because the filter match the test case name",
            12,
            model.testFunctions.length );
      }
      
      public function testRefreshFilterOnlyTests() : void
      {
         var i : int;
         
         for ( i = 1; i < 13; i++ )
         {
            model.testFunctions.addItem( generateTestCaseRowData( "testCase" + i, "1", "2", 5 ) );
         }
         model.testFunctions.addItem( generateTestCaseRowData( "testCase" + i, "1", "1", 0 ) );
         for ( i = 1; i < 13; i++ )
         {
            model.testFunctions.addItem( generateTestCaseRowData( "testCase" + i, "1", "2", 5 ) );
         }
         
         model.selectedTestFunctionStatus = TestfFunctionStatuses.ALL; 
         model.filterText = "";         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 25 " + 
            "(selectedTestCaseStatus = AllTestCaseStatus and filterText = '' applied)",
            25,
            model.testFunctions.length );
         
         model.selectedTestFunctionStatus = TestfFunctionStatuses.EMPTY; 
         model.filterText = "";         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 1 " + 
            "(selectedTestCaseStatus = EmptyTestCaseStatus and filterText = '' applied)",
            1,
            model.testFunctions.length );

         model.selectedTestFunctionStatus = TestfFunctionStatuses.ERRORS_AND_FAILURES; 
         model.filterText = "";         
         model.refresh();
         
         assertEquals(
            "model.testFunctions.length should be 24 " + 
            "(selectedTestCaseStatus = ErrorTestCaseStatus and filterText = '' applied)",
            24,
            model.testFunctions.length );
      }
      
      private function generateTestCaseRowData(
                  methodName : String, 
                  expectedResult : String,
                  actualResult : String,
                  assertionsMade : int ) : TestFunctionRowData
      {
         var testCase : TestFunctionRowData = new TestFunctionRowData();
         
         testCase.testMethodName = methodName;
         testCase.expectedResult = expectedResult;
         testCase.actualResult = actualResult;
         testCase.testSuccessful = expectedResult == actualResult;
         testCase.testCase = new TestCase();
         testCase.testCase.assertionsMade = assertionsMade;
         
         return testCase;
      }
   }
}