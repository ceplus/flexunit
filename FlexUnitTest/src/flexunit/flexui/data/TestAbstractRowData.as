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
   import flexunit.framework.TestCase;

   public class TestAbstractRowData extends TestCase
   {
      private var model : AbstractRowData
         = new AbstractRowData();
      
      public function testClassName() : void
      {
         model.qualifiedClassName = "flexunit.flexui.data::TestTestSummaryRowData";
         
         assertEquals(
            "model.className is not extracted correctly from the qualified name",
            "TestTestSummaryRowData",
            model.className );

         model.qualifiedClassName = "flexunit.flexui.data::TestFoo";
         
         assertEquals(
            "model.className is not extracted correctly from the qualified name",
            "TestFoo",
            model.className );
      }
      
      public function testAssertionsMade() : void
      {
         try
         {
            model.assertionsMade;
            
            fail( "an error should have been thrown" );
         }
         catch( e : Error )
         {
         }
      }

      public function testFailIcon() : void
      {
         try
         {
            model.failIcon;
            
            fail( "an error should have been thrown" );
         }
         catch( e : Error )
         {
         }
      }

      public function testPassIcon() : void
      {
         try
         {
            model.passIcon;
            
            fail( "an error should have been thrown" );
         }
         catch( e : Error )
         {
         }
      }

      public function testIsAverage() : void
      {
         try
         {
            model.isAverage;
            
            fail( "an error should have been thrown" );
         }
         catch( e : Error )
         {
         }
      }
   }
}