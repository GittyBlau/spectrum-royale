package com.unhurdle.spectrum
{
  COMPILE::JS{
    import org.apache.royale.core.WrappedHTMLElement;
  }
  import com.unhurdle.spectrum.utils.PointerDrag;
  import org.apache.royale.events.Event;
  import org.apache.royale.utils.number.pinValue;
  public class RampSlider extends SliderBase
  {
    public function RampSlider()
    {
      super();
      usesPointerDrag = true;
      typeNames = getSelector() + " " + valueToSelector("ramp");
    }

    private var handle:HTMLElement;
    private var pointerDrag:PointerDrag;
    
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
        var elem:WrappedHTMLElement = super.createElement();
        controlsContainer = newElement("div",appendSelector("-controls"));
        var ramp:HTMLDivElement = newElement("div") as HTMLDivElement;
        ramp.className = appendSelector("-ramp");
        var svgElement:SVGElement = newIconSVG("");
        var pathElement:SVGPathElement = newSVGElement("path","") as SVGPathElement;
        pathElement.setAttribute("d","M240,4v8c0,2.3-1.9,4.1-4.2,4L1,9C0.4,9,0,8.5,0,8c0-0.5,0.4-1,1-1l234.8-7C238.1-0.1,240,1.7,240,4z");
        svgElement.setAttribute("viewBox","0 0 240 16");
        svgElement.setAttribute("preserveAspectRatio","none");
        svgElement.setAttribute("aria-hidden",true);
        svgElement.appendChild(pathElement);
        ramp.appendChild(svgElement);
        controlsContainer.appendChild(ramp);
        handle = newElement("div",appendSelector("-handle"));
        handle.style.left = "40%"
        input = newElement("input",appendSelector("-input")) as HTMLInputElement;
        input.type = "range";
        input.step = "1";
        max = 50;
        handle.appendChild(input);
        controlsContainer.appendChild(handle);
        elem.appendChild(controlsContainer);
        input.addEventListener("input", handleNativeInput);
        pointerDrag = new PointerDrag(element, handlePointerStart, handlePointerMove, handlePointerEnd, "pan-y");
        return elem;
    }
    
    override protected function positionElements():void{
			var range:Number = max - min;
			var percent:Number = range == 0 ? 0 : pinValue((value - min) / range * 100, 0, 100);
			handle.style.left = percent + "%";
		}

    public function get value():Number
    {
    	return Number(input.value);
    }

    public function set value(value:Number):void
    {      
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
			var newValue:Number = getPositionValue(event.clientX - bounds.left, bounds.width);
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

    private function getPositionValue(position:Number, width:Number):Number {
			var newValue:Number = min + (max - min) * pinValue(position, 0, width) / width;
			if(step > 0){
				newValue = min + Math.round((newValue - min) / step) * step;
			}
			return pinValue(newValue, min, max);
    }
  }
}
