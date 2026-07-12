package com.unhurdle.spectrum
{
  COMPILE::JS{
    import org.apache.royale.core.WrappedHTMLElement;
  }
  import com.unhurdle.spectrum.utils.PointerDrag;
  import org.apache.royale.events.Event;
  import org.apache.royale.utils.number.pinValue;
  public class VideoPlayerSlider extends SliderBase
  {
    public function VideoPlayerSlider()
    {
      super();
      usesPointerDrag = true;
    }
    override protected function getSelector():String{
      return "spectrum-Slider";
    }

    private var handle:HTMLElement;
 		private var leftTrack:HTMLElement;
   	private var rightTrack:HTMLElement;
		private var leftBuffer:HTMLElement;
  	private var rightBuffer:HTMLElement;
    private var pointerDrag:PointerDrag;
    
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = super.createElement();
      controlsContainer = newElement("div",appendSelector("-controls"));
      //first track
      leftTrack = newElement("div",appendSelector("-track"));
      controlsContainer.appendChild(leftTrack);
      //first buffer
      leftBuffer = newElement("div",appendSelector("-buffer"));
      // need this?
      // leftBuffer.setAttribute("role","progressbar");
      // leftBuffer.setAttribute("aria-valuemin","0");
      // leftBuffer.setAttribute("aria-valuemax","100");
      // leftBuffer.setAttribute("aria-valuenow","50");
      controlsContainer.appendChild(leftBuffer);
      //handle
      handle = newElement("div",appendSelector("-handle"));
      input = newElement("input",appendSelector("-input")) as HTMLInputElement;
      input.type = "range";
      input.step = "1";
      // leftBuffer.setAttribute("aria-valuetext","3:48");
      max = 100;
      handle.appendChild(input);
      controlsContainer.appendChild(handle);
      //second buffer
      rightBuffer = newElement("div",appendSelector("-buffer"));
      controlsContainer.appendChild(rightBuffer);
      //second track
      rightTrack = newElement("div",appendSelector("-track"));
      controlsContainer.appendChild(rightTrack);

      elem.appendChild(controlsContainer);
  input.addEventListener("input", handleNativeInput);
  pointerDrag = new PointerDrag(element, handlePointerStart, handlePointerMove, handlePointerEnd, "pan-y");
      return elem;
    }
    public function get value():Number
    {
    	return Number(input.value);
    }

    public function set value(value:Number):void
    {
			//TODO why is this a string?
			input.value = "" + value;
			if(parent){
				positionElements();
			}
			if(valueNode){
				valueNode.text = "" + value;
			}
    }
    override protected function getValue():String{
			return input.value;
		}
    override protected function positionElements():void{
      var range:Number = max - min;
      var percent:Number = range == 0 ? 0 : pinValue((value - min) / range * 100, 0, 100);
        handle.style.left = percent + "%";
      if (leftTrack && rightTrack) {
        leftTrack.style.width = percent + '%';
        rightTrack.style.width = (100 - percent) + '%';
      }
      positionBuffer(percent);
    }

    override protected function enableDisableInput(value:Boolean):void{
      input.disabled = value;
      COMPILE::JS
      {
        pointerDrag.enabled = !value;
      }
    }

    COMPILE::JS
    private function handlePointerStart(event:*):Boolean {
      if(event.target === input){
        return false;
      }
      handle.classList.add("is-dragged");
      return true;
    }

    COMPILE::JS
    private function handlePointerMove(event:*):void {
      if(disabled){
        return;
      }
      var bounds:ClientRect = element.getBoundingClientRect();
      if(bounds.width == 0){
        return;
      }
      var newValue:Number = min + (max - min) * pinValue(event.clientX - bounds.left, 0, bounds.width) / bounds.width;
      if(step > 0){
        newValue = min + Math.round((newValue - min) / step) * step;
      }
      newValue = pinValue(newValue, min, max);
      if(value != newValue){
        value = newValue;
        dispatchEvent(new Event("change"));
      }
    }

    COMPILE::JS
    private function handlePointerEnd(event:*, cancelled:Boolean):void {
      handle.classList.remove("is-dragged");
    }

    COMPILE::JS
    private function handleNativeInput(event:*):void {
      positionElements();
      if(valueNode){
        valueNode.text = input.value;
      }
      dispatchEvent(new Event("change"));
    }

    private function positionBuffer(percent:Number):void {
      var bufferedAmount:Number = 50; //need to be buffers long...

      if (percent >= bufferedAmount) {
        // Don't show right buffer bar
        rightBuffer.style.width = 0;
        rightBuffer.style.left = bufferedAmount +'%';
        leftBuffer.style.width = bufferedAmount + '%';
      }
      else if (percent < bufferedAmount){
        leftBuffer.style.width = percent + '%';
        rightBuffer.style.width = bufferedAmount -percent +'%';
        rightBuffer.style.left = percent + '%';
        rightBuffer.style.right = (100 - bufferedAmount) + '%';
      }
    }
  }
}
