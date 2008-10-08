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
   
   import flexunit.flexui.patterns.AbstractPattern;
   import flexunit.framework.AssertStringFormats;
   import flexunit.framework.TestCase;
   import com.adobe.ac.flexunit.utils.ErrorGenerator;
   
   import mx.utils.StringUtil;

   public class TestTestFunctionRowData extends TestCase
   {
      private var model : TestFunctionRowData
         = new TestFunctionRowData();      
         
      public function testErrorUndefined() : void
      {
         testErrorParameterized(
            printErrorMessage( AssertStringFormats.UNDEFINED, null ),
            AbstractPattern.NOT_UNDEFINED,
            AbstractPattern.NULL );
      }
      
      public function testErrorNoMatch() : void
      {
         testErrorParameterized( 
            printErrorMessage( AssertStringFormats.NO_MATCH, "frfr", '/\d\d.*\s/' ),
            StringUtil.substitute( AbstractPattern.STRING_MATCHING ,'/\d\d.*\s/' ),
            "frfr" );
      }
      
      public function testErrorNotNull() : void
      {
         testErrorParameterized( 
            printErrorMessage( AssertStringFormats.NOT_NULL, "[object Object]" ),
            AbstractPattern.NULL,
            "[object Object]" );
      }
      
      public function testErrorNotUndefined() : void
      {
         testErrorParameterized(
            printErrorMessage( AssertStringFormats.NOT_UNDEFINED, "[object Object]" ),
            AbstractPattern.UNDEFINED,
            "[object Object]" );
      }
      
      public function testErrorNotContained() : void
      {
         testErrorParameterized( 
            printErrorMessage( AssertStringFormats.NOT_CONTAINED, "lala", "frfr" ),
            StringUtil.substitute( AbstractPattern.SUBSTRING_OF, 'frfr' ),
            "lala" );
      }
      
      public function testErrorTrue() : void
      {
         testErrorParameterized(
            printErrorMessage( AssertStringFormats.EXPECTED_BUT_WAS, true, false ),
            'true',
            "false" );
      }
      
      public function testErrorFalse() : void
      {
         testErrorParameterized( 
            printErrorMessage( AssertStringFormats.EXPECTED_BUT_WAS, false, true ),
            'false',
            "true" );
      }
      
      public function testErrorNull() : void
      {
         testErrorParameterized( 
            printErrorMessage( AssertStringFormats.NULL, null ),
            AbstractPattern.NOT_NULL,
            AbstractPattern.NULL );
      }
      
      public function testNotContained() : void
      {            
         testErrorParameterized(
            printErrorMessage( AssertStringFormats.NOT_CONTAINED, "nothing", "longstring" ),
            StringUtil.substitute( AbstractPattern.SUBSTRING_OF, 'longstring' ),
            'nothing' );
      }
      
      public function testMatch() : void
      {            
         testErrorParameterized(
            printErrorMessage( AssertStringFormats.MATCH, "1134", "/\d\d.*/" ),
            StringUtil.substitute( AbstractPattern.STRING_NOT_MATCHING, '/\d\d.*/' ),
            StringUtil.substitute( AbstractPattern.STRING_MATCHING , '/\d\d.*/' ) );
      }
      
      private function testErrorParameterized( 
               errorMessage : String, 
               expectedResult : String,
               actualResult : String ) : void
      {
         var e : Error = ErrorGenerator.generate( errorMessage );
         
         model.error = e;
         
         assertEquals(
            "model.errorMessage is not correctly set",
            errorMessage,
            model.errorMessage );

         assertEquals(
            "model.actualResult is not correctly set",
            actualResult,
            model.actualResult );

         assertEquals(
            "model.expectedResult is not correctly set",
            expectedResult,
            model.expectedResult );
         
         assertContained(
            "The error location is not bold (as expected)",
            "<b>",
            model.stackTrace );
            
         assertContained(
            "The stackTrace is not html printed",
            "<br/>",
            model.stackTrace );
         
         assertNotNull(
            "The error location should be set",
            model.location );
            
         assertTrue(
            "The error location should not be equal to an empty string",
            model.location != "" );
            
         assertMatch(
            "The error location is not correctly formatted",
            /ErrorGenerator\.as \(line \d+\)/,
            model.location );
      }
      
      private function printErrorMessage( template : String, ... rest ) : String
      {
         return StringUtil.substitute( template, rest );
      }
   }
}