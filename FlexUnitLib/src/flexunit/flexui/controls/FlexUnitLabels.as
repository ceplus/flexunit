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

package flexunit.flexui.controls
{
   import mx.utils.StringUtil;
   
   public class FlexUnitLabels
   {      
      /* TITLES */
      public static const FLEXUNIT_RUNNER : String = "FlexUnit Runner";
      public static const POWERED_BY_ADOBE_CONSULTING : String = "powered by Adobe Consulting";
      public static const TEST_CASES : String = "TEST CASES";
      public static const TEST_SUITE : String = "TEST SUITE";
      public static const RESULT_DETAILS : String = "RESULT DETAILS";
      
      /* FILTERS */
      public static const ALL : String = "All results";
      public static const EMPTY : String = "Empty tests";
      public static const FAILURES_AND_ERRORS : String = "Failures & errors";
      public static const FILTER_PROMPT : String = "Type filter";
      public static const FILTER_TOOLTIP : String = "You can filter either on methods names, or expected values or actual values";
      public static const ASSERTIONS_SLIDER_TOOLTIP : String = "Display between {0} and {1} assertions";
      
      /* TEST CASES TREE */
      public static const CASE : String = "Case";
      public static const RESULT : String = "Result";
      public static const ASSERTS : String = "Asserts";
      public static const ASSERTIONS_PER_TEST : String = "Assertions per test";
      public static const ASSERTIONS_PER_TEST_IN_AVERAGE : String = "assertions " + PER_TEST + " " + ON_AVERAGE;
      public static const EXPECTED : String = "Expected";
      public static const ACTUAL : String = "Actual";
      
      /* RESULTS POD*/
      public static const ASSERTIONS_MADE_MESSAGE : String = "{0} assertion{1} {2} made {3}";
     	public static const PER_TEST : String = "per test"; 
      public static const DURING_THIS_TEST : String = "during this test";
      public static const ON_AVERAGE : String = "on average";
      public static const AN_AVERAGE_OF : String = "An average of ";
      
      public static const PASSED_TESTS_NUMBER_MESSAGE : String = "{0} of {1} passed";
      
      public static const RUNNING_TESTS : String = "Running tests...";
      public static const FUNCTION : String = "Function";
      public static const LOCATION : String = "Location";
      public static const MESSAGE : String = "Message";
      public static const STACKTRACE : String = "Stacktrace";
      
      /* TEST COMPLETE POD */
      public static const TESTS_RUN : String = "Tests run";
      public static const TIME_TAKEN : String = "Time taken";
      public static const ERRORS : String = "Errors";
      public static const FAILURES : String = "Failures";
      
      /* CHART */
      public static const CHART_TITLE : String = "Tests number per assertions number";
      public static const CHART_TOOLTIP : String = "Click to close the popup";
      
      public static function formatAssertions(
               formattedAssertionsMade : String,
               isAverage : Boolean ) : String
      {
         var assertionsMade : Number = Number( formattedAssertionsMade );
         
         return StringUtil.substitute( ASSERTIONS_MADE_MESSAGE,
                     ( isAverage ? AN_AVERAGE_OF : "" ) + formattedAssertionsMade,
                     assertionsMade != 1 ? "s" : "",
                     assertionsMade != 1 ? "were" : "was",
                     isAverage ? PER_TEST : DURING_THIS_TEST );
      }
   }
}