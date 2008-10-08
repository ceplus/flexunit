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

   import flexunit.framework.*;
   
   public class AsynchronousTestCase extends TestCase
   {   
       public function AsynchronousTestCase(name : String)
       {
           super(name);
       }
   
       override public function setUp() : void
       {
           dispatcher = new AsynchronousValueDispatcher();
	   assertionsOnTeardown = null;
       }

       override public function tearDown() : void
       {
	   if (null != assertionsOnTeardown) {
	       assertionsOnTeardown();
	   }
       }
   
       public function testInTimePass() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function testInTimeFail() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchValue(VALUE_2, TIME_PASS);
       }
   
       public function testInTimeError() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchError(TIME_PASS);
       }
   
       public function testTooLatePass() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchValue(VALUE_1, TIME_FAIL);
       }
   
       public function testTooLateFail() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchValue(VALUE_2, TIME_FAIL);
       }
   
       public function testTooLateError() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1));
           dispatcher.dispatchError(TIME_FAIL);
       }
   
       public function handleValue(event : ValueEvent, expected : String) : void
       {
           var actual : String = event.value;
           Assert.assertEquals(expected, actual);
       }
   
   
       public function testSecondInTimePass() : void
       {
	   listeningAsync = addAsync(handleFirstValueThenPassInTime, TIME_SYNC, VALUE_1);
           dispatcher.addEventListener("value", listeningAsync);
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function handleFirstValueThenPassInTime(event : ValueEvent, expected : String) : void
       {
           var actual : String = event.value;
           Assert.assertEquals(expected, actual);
	   dispatcher.removeEventListener("value", listeningAsync);
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_2));
           dispatcher.dispatchValue(VALUE_2, TIME_PASS);
       }
   
       public function testSecondInTimeFail() : void
       {
	   listeningAsync = addAsync(handleFirstValueThenFailInTime, TIME_SYNC, VALUE_1);
           dispatcher.addEventListener("value", listeningAsync);
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function handleFirstValueThenFailInTime(event : ValueEvent, expected : String) : void
       {
           var actual : String = event.value;
           Assert.assertEquals(expected, actual);
	   dispatcher.removeEventListener("value", listeningAsync);
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_2));
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function testSecondTooLatePass() : void
       {
	   listeningAsync = addAsync(handleFirstValueThenPassTooLate, TIME_SYNC, VALUE_1);
           dispatcher.addEventListener("value", listeningAsync);
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function handleFirstValueThenPassTooLate(event : ValueEvent, expected : String) : void
       {
           var actual : String = event.value;
           Assert.assertEquals(expected, actual);
	   dispatcher.removeEventListener("value", listeningAsync);
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_2));
           dispatcher.dispatchValue(VALUE_2, TIME_FAIL);
       }
   
       public function testSecondTooLateFail() : void
       {
	   listeningAsync = addAsync(handleFirstValueThenFailTooLate, TIME_SYNC, VALUE_1);
           dispatcher.addEventListener("value", listeningAsync);
           dispatcher.dispatchValue(VALUE_1, TIME_PASS);
       }
   
       public function handleFirstValueThenFailTooLate(event : ValueEvent, expected : String) : void
       {
           var actual : String = event.value;
           Assert.assertEquals(expected, actual);
	   dispatcher.removeEventListener("value", listeningAsync);
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_2));
           dispatcher.dispatchValue(VALUE_1, TIME_FAIL);
       }
   
       public function testTimeoutFunctionPass() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1, handleTimeoutPass));
           dispatcher.dispatchValue(VALUE_1, TIME_FAIL);
       }
   
       public function handleTimeoutPass(expected : String) : void
       {
           //do nothing, this should turn into a pass
       }
   
       public function testTimeoutFunctionFail() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1, handleTimeoutFail));
           dispatcher.dispatchValue(VALUE_1, TIME_FAIL);
       }

       public function handleTimeoutFail(expected : String) : void
       {
           fail("async method not called in time");
       }

       public function testTimeoutFunctionCalledTwiceInOrder() : void
       {
	   var actualFirstCalled : Boolean = false;
	   var actualSecondCalled : Boolean = false;
	   var actualInvocationCount : int = 0;
	   var expectedInvocationCount : int = 2;

	   function shouldCalledAtFirst(expected : String) : void {
	       Assert.assertEquals(false, actualFirstCalled);
	       Assert.assertEquals(false, actualSecondCalled);
	       actualFirstCalled = true;
	       actualInvocationCount++;
	   };

	   function shouldCalledAtSecond(expected : String) : void {
	       Assert.assertEquals(true,  actualFirstCalled);
	       Assert.assertEquals(false, actualSecondCalled);
	       actualSecondCalled = true;
	       actualInvocationCount++;
	   }

	   // registation order should NOT matter.

           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC_MORE, VALUE_2, shouldCalledAtSecond));
	   dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1, shouldCalledAtFirst));

           dispatcher.dispatchValue(VALUE_1, TIME_FAIL);

	   assertionsOnTeardown = function() : void {
	       Assert.assertEquals(actualInvocationCount, expectedInvocationCount);
	   };
       }

 
       public function testHandleEventForMultipleListenersOrdered() : void
       {
 	   var listen1:Function = function l1(event : ValueEvent) : void { Assert.assertEquals(event.value, VALUE_1); };
 	   var dispatcher1:AsynchronousValueDispatcher = new AsynchronousValueDispatcher();
	   dispatcher1.addEventListener("value", addAsync(listen1, TIME_SYNC));
 
 	   var listen2:Function = function l2(event : ValueEvent) : void { Assert.assertEquals(event.value, VALUE_2); };
 	   var dispatcher2:AsynchronousValueDispatcher = new AsynchronousValueDispatcher();
	   dispatcher2.addEventListener("value", addAsync(listen2, TIME_SYNC));
 	   
	   dispatcher1.dispatchValue(VALUE_1, 0);
	   dispatcher2.dispatchValue(VALUE_2, TIME_PASS);
       }
 
       public function testHandleEventForMultipleListenersReverse() : void
       {
 	   var listen1:Function = function l1(event : ValueEvent) : void { Assert.assertEquals(event.value, VALUE_1); };
 	   var dispatcher1:AsynchronousValueDispatcher = new AsynchronousValueDispatcher();
	   dispatcher1.addEventListener("value", addAsync(listen1, TIME_SYNC));
 
 	   var listen2:Function = function l2(event : ValueEvent) : void { Assert.assertEquals(event.value, VALUE_2); };
 	   var dispatcher2:AsynchronousValueDispatcher = new AsynchronousValueDispatcher();
	   dispatcher2.addEventListener("value", addAsync(listen2, TIME_SYNC));
 	   
 	   // expiration order should NOT matter
	   dispatcher1.dispatchValue(VALUE_1, TIME_PASS);
	   dispatcher2.dispatchValue(VALUE_2, 0);
       }
 
       public function testHandleEventAfterFirstEvent() : void
       {
 	   var ncalled:int = 0;
 
 	   var secondListener:Function = addAsync(function(event:ValueEvent) : void {
 		   assertEquals(VALUE_2, event.value);
 		   ncalled++;
 	       }, TIME_SYNC);
 	   var firstListener:Function = addAsync(function(event:ValueEvent) : void {
 		   assertEquals(VALUE_2, event.value);
 		   ncalled++;
 	       }, TIME_SYNC);
 
 	   var dispatcher2:AsynchronousValueDispatcher = new AsynchronousValueDispatcher();
	   dispatcher2.addEventListener("value", firstListener);
	   dispatcher2.addEventListener("value", secondListener);
 
	   dispatcher.addEventListener("value", addAsync(function(event:ValueEvent) : void {
 		       assertEquals(VALUE_1, event.value);
 		       dispatcher2.dispatchValue(VALUE_2, 0); 
 		   }, TIME_SYNC));
 	   dispatcher.dispatchValue(VALUE_1, 0); 
 
 	   assertionsOnTeardown = function() : void {
 	       Assert.assertEquals(2, ncalled);
 	   };
       }
   
       public function testNotReallyAsynchronousPass() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1, handleValue));
           dispatcher.dispatchValue(VALUE_1, 0);
       }
   
       public function testNotReallyAsynchronousFail() : void
       {
           dispatcher.addEventListener("value", addAsync(handleValue, TIME_SYNC, VALUE_1, handleValue));
           dispatcher.dispatchValue(VALUE_2, 0);
       }
   
       private var dispatcher : AsynchronousValueDispatcher;
       private var listeningAsync : Function;
       private var assertionsOnTeardown : Function;
   
       private static var VALUE_1 : String = "value1";
       private static var VALUE_2 : String = "value2";
       public static var TIME_PASS : int = 50;
       public static var TIME_FAIL : int = 250;
       public static var TIME_SYNC : int = 100;
       public static var TIME_SYNC_MORE : int = 110;
   }
}