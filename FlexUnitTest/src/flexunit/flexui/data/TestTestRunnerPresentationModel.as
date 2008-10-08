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
   import flexunit.flexui.data.filter.ErrorTestFunctionStatus;
   import flexunit.flexui.event.TestRunnerBasePresentationModelProperyChangedEvent;
   import flexunit.framework.EventfulTestCase;

   public class TestTestRunnerPresentationModel extends EventfulTestCase
   {
      private var model : TestRunnerBasePresentationModel
         = new TestRunnerBasePresentationModel();
      
      public function testLaunchTests() : void
      {
         assertFalse(
            "model.testsRunning should be false before launching tests",
            model.testsRunning );
         
         model.launchTests();

         assertTrue(
            "model.testsRunning should be true after launching tests",
            model.testsRunning );
         
         assertNotNull(
            "model.dataProvider should not be null",
            model.dataProvider );
      }
      
      public function testEndTimer() : void
      {
         model.launchTests();
         
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_FAILURES_CHANGED );

         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.TEST_SUITE_RUN_DURATION_CHANGED );

         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_ERRORS_CHANGED );
            
         model.endTimer();
         
         assertEvents(
            "3 events should have been dispatched during model.endTimer()" );
         
         assertFalse(
            "model.testsRunning should be false",
            model.testsRunning );
         
         assertMatch(
            "model.suiteFormattedDuration is not correctly formatted",
            /.+\.?.*s$/,
            model.suiteDurationFormatted );
      }
      
      public function testNumTestsRun() : void
      {
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.PROGRESS_CHANGED );
         
         model.numTestsRun = 10;
         
         assertEvents(
            "PROGRESS_CHANGED should have been dispatched" );
         
         assertEquals(
            "model.numTestsRun should be set to 10",
            10,
            model.numTestsRun );
      }

      public function testFilterSectionEnabled() : void
      {
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.FILTER_ENABLE_CHANGED );
         
         model.filterSectionEnabled = true;
         
         assertEvents(
            "FILTER_ENABLE_CHANGED should have been dispatched" );
         
         assertTrue(
            "model.filterSectionEnabled should be set to true",
            model.filterSectionEnabled );

         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.FILTER_ENABLE_CHANGED );
         
         model.filterSectionEnabled = false;
         
         assertEvents(
            "FILTER_ENABLE_CHANGED should have been dispatched" );
         
         assertFalse(
            "model.filterSectionEnabled should be set to true",
            model.filterSectionEnabled );
      }

      public function testFilterOnlyErrors() : void
      {
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.FILTER_CHANGED );
         
         model.filterModel.selectedTestFunctionStatus = new ErrorTestFunctionStatus();
         
         assertEvents(
            "FILTER_CHANGED should have been dispatched" );
         
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.FILTER_CHANGED );         
      }
      
      public function testRowSelected() : void
      {
         var testCase : TestFunctionRowData = new TestFunctionRowData();
         var testClass : TestCaseData = new TestCaseData( testCase );
         
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.ROW_SELECTED_CHANGED );
         
         model.rowSelected = testClass;
         
         assertEvents(
            "ROW_SELECTED_CHANGED should have been dispatched" );
         
         assertEquals(
            "model.rowSelected has not been correctly set",
            testClass,
            model.rowSelected );
         
         assertNotNull(
            "model.testClassSelected should not be null",
            model.testCaseSelected );
         
         assertEquals(
            "model.testClassSelected is not correctly set",
            testClass,
            model.testCaseSelected );

         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.ROW_SELECTED_CHANGED );
         
         model.rowSelected = testCase;
         
         assertEvents(
            "ROW_SELECTED_CHANGED should have been dispatched" );
         
         assertEquals(
            "model.rowSelected has not been correctly set",
            testCase,
            model.rowSelected );
         
         assertNotNull(
            "model.testCaseSelected should not be null",
            model.testFunctionSelected );
         
         assertEquals(
            "model.testCaseSelected is not correctly set",
            testCase,
            model.testFunctionSelected );
      }
      
      public function testAddFailures() : void
      {
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_FAILURES_CHANGED );
         
         assertEquals(
            "model.totalFailures should equal to 0",
            0,
            model.totalFailures );
         
         model.addFailure();
         
         assertEquals(
            "model.totalFailures should have been incremented",
            1,
            model.totalFailures );
         
         assertEvents(
            "TOTAL_FAILURES_CHANGED should have been dispatched" );
      }

      public function testAddErrors() : void
      {      
         listenForEvent(
            model,
            TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_ERRORS_CHANGED );

         assertEquals(
            "model.totalFailures should equal to 0",
            0,
            model.totalErrors );
         
         model.addError();
         
         assertEquals(
            "model.totalFailures should have been incremented",
            1,
            model.totalErrors );
         
         assertEvents( "TOTAL_ERRORS_CHANGED should have been dispatched" );
      }     

      public function testAddTestRowToHierarchicalList() : void
      {
         var test : SampleTestCase = new SampleTestCase();
         

         model.launchTests();

         addTestRow( test, "test1", false, 1 );
         addTestRow( test, "test2", true, 2 );
         addTestRow( test, "test3", true, 3 );
         addTestRow( test, "test4", true, 4 );
         addTestRow( test, "test5", true, 5 );
         addTestRow( test, "test6", true, 6 );
         
         model.endTimer();
      }
      
      private function addTestRow( 
                  test : SampleTestCase, 
                  methodName : String, 
                  success : Boolean,
                  expectedChildrenLength : int ) : void
      {
         var rowAdded : TestFunctionRowData;
         
         test.methodName = methodName;

         rowAdded = model.addTestRowToHierarchicalList(
            test, null, success, false );
         
         assertEquals(
            "model.dataProvider.length is incorrect",
            1,
            model.dataProvider.length );
         
         assertNotNull(
            "rowAdded.parentTestCaseSummary is null",
            rowAdded.parentTestCaseSummary );
            
         assertEquals(
            "rowAdded.parentTestCaseSummary.children.length is incorrect",
            expectedChildrenLength,
            rowAdded.parentTestCaseSummary.children.length );
      }
   }
}