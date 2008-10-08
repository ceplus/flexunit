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

package flexunit.framework
{
   import flash.events.*;
   import flash.utils.*;
   
   import mx.utils.StringUtil;

   public class AsyncTestHelper
   {
       public function AsyncTestHelper( testCase : TestCase, testResult : TestResult )
       {
           this.testCase = testCase;
           this.testResult = testResult;
       }

   //------------------------------------------------------------------------------

       public function startAsync() : void
       {
	   if (0 < receivedCalls.length)
           {
               testResult.continueRun( testCase );
           }
           else
           {
	       loadAsync();
           }
       }

   //------------------------------------------------------------------------------


       public function loadAsync() : void
       {
           var freshes : Array = testCase.getFreshAsyncs();
           //BUG 114824 WORKAROUND
	   freshes.forEach(function(async:*, index:int, array:Array) : void {
		   if (!async.timer)
		   {
		       async.timer = new Timer( async.timeout, 1 );
		       async.timer.addEventListener( TimerEvent.TIMER, 
						     function(event:TimerEvent) : void { timerHandler(event, async); } );
		       async.timer.start();
		   }
	       });
           //END WORKAROUND
       }

   //------------------------------------------------------------------------------

       public function runNext() : void
       {
	   var call : Object = receivedCalls.shift();

	   var phase:String = call.async.phase;
	   call.async.phase = "done";

	   switch (phase)
	   {
	   case "fresh": {
	       var extraData : Object = call.async.extraData;
	       var func  : Function = call.async.func;
	       var objToPass : Array = call.args;

               if ( extraData != null )
               {
		   objToPass.push(extraData);
               }

	       func.apply(this, objToPass);
	   }    break;
	   case "failed": {
	       var failFunc:Function = call.async.failFunc;
	       var failExtraData:Object = call.async.extraData;
	       if (null != failFunc)
	       { 
		   failFunc( failExtraData );
	       }
	       else
	       {
		   Assert.fail( StringUtil.substitute( AssertStringFormats.ASYNC_CALL_NOT_FIRED, 
						       call.async.timer.delay ) );
 	       }
	   }   break;
	   case "done":
	   default:
	       break;
	   }
       }

   //------------------------------------------------------------------------------

       public function timerHandler( event : TimerEvent, async : Object ) : void
       {
	   (async.timer as Timer).stop();
	   async.phase = "failed";
	   receivedCalls.push({args: null, async: async});
	   testResult.continueRun( testCase );
       }

   //------------------------------------------------------------------------------

       public function handleEvent(async : Object, args:Array) : void
       {
	   var wasReallyAsync : Boolean = false;

	   if (async.timer)
	   {
	       wasReallyAsync = (async.timer as Timer).running;
	       (async.timer as Timer).stop();
	   }

	   if (async.phase == "fresh")
	   {
	       receivedCalls.push({args: args, async: async});

	       if ( wasReallyAsync )
	       {
		   testResult.continueRun( testCase );
	       }
	   }
       }

       public function makeHandleEventFor(async : Object) : Function
       {
	   return function (... rest) : void { handleEvent(async, rest); };
       }


   //------------------------------------------------------------------------------

       //IResponder methods here (they'd look similar to handleEvent) ...

   //------------------------------------------------------------------------------

       private var testCase : TestCase;
       private var testResult : TestResult;

       private var receivedCalls:Array = [];
   }
}
