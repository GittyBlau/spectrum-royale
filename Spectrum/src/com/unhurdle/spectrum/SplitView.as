package com.unhurdle.spectrum
{
	import com.unhurdle.spectrum.utils.PointerDrag;
  import org.apache.royale.core.IChild;
  import org.apache.royale.utils.number.pinValue;
  import org.apache.royale.utils.number.getPercent;
  import org.apache.royale.core.ILayoutChild;

	[Event(name="resizeStart", type="org.apache.royale.events.Event")]
  [Event(name="resizeFinish", type="org.apache.royale.events.Event")]
  public class SplitView extends Group
  {

		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZE_FINISH:String = "resizeFinish";

    /**
     * <inject_html>
     * <link rel="stylesheet" href="assets/css/components/splitview/dist.css">
     * </inject_html>
     * 
     */
    public function SplitView()
    {
      super();
			direction = "horizontal"
    }
    override protected function getSelector():String{
        return "spectrum-SplitView";
    }
		private var _splitter:Splitter;
		private var pointerDrag:PointerDrag;
		protected function get splitter():Splitter{
			if(!_splitter){
				_splitter = new Splitter();
				COMPILE::JS{
					splitter.cursor = direction == "horizontal" ? "col-resize" : "row-resize";
					_splitter.element.style.userSelect = "none";
					_splitter.element.style.webkitUserSelect = "none";
					_splitter.element.style.setProperty("-webkit-touch-callout","none");
					pointerDrag = new PointerDrag(_splitter.element, handlePointerStart, handlePointerMove, handlePointerEnd, "none");
					pointerDrag.enabled = isDraggable;
				}
			}
			return _splitter;
		}

		private var _isDraggable:Boolean;

		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}

		public function set isDraggable(value:Boolean):void
		{
			if(_isDraggable == value){
				return;
			}
			splitter.toggle("is-draggable",value);
				// value? splitter.classList.add("is-draggable"): splitter.classList.remove("is-draggable");
			_isDraggable = value;
			splitter.draggable = value;
			splitter.touchHitAreaDirection = direction;
			if(pointerDrag){
				pointerDrag.enabled = value;
			}
		}
		protected function positionElements(val:Number):void{
			positionCollapsed = val;
			var percent:Number = val;
			if(numElements > 2){
				if(direction === "horizontal"){
					(getElementAt(0) as ILayoutChild).percentWidth = percent;
					splitter.setStyle("left","0");
					(getElementAt(2) as ILayoutChild).percentWidth = 100 - percent;
				} else {
					(getElementAt(0) as ILayoutChild).percentHeight = percent;
					splitter.setStyle("top","0");
					(getElementAt(2) as ILayoutChild).percentHeight = 100 - percent;
				}
			}
		}
		private var _position:Number;

		public function get position():Number
		{
			return _position;
		}

		public function set position(value:Number):void
		{
			if(!isNaN(value)){
				_position = value;
				positionElements(value);
				positionCollapsed = value;
			}
		}

		private var _positionCollapsed:Number;
		private function get positionCollapsed():Number
		{
			return _positionCollapsed;
		}
		private function set positionCollapsed(value:Number):void
		{
			if(value != _positionCollapsed){
				var oldpositionCollapsed:String;
				if(_positionCollapsed < 1){
					oldpositionCollapsed = "is-collapsed-start";
					splitter.toggle(oldpositionCollapsed,false);
					// splitter.classList.remove(oldpositionCollapsed);
				} else if(_positionCollapsed > 99){
					oldpositionCollapsed = "is-collapsed-end";
					splitter.toggle(oldpositionCollapsed,false);
					// splitter.classList.remove(oldpositionCollapsed);
				}
				if(value < 1 || value > 99){
					var newpositionCollapsed:String;
					if(value < 1){
						newpositionCollapsed = "is-collapsed-start";
					} else{
						newpositionCollapsed = "is-collapsed-end";
					}
					splitter.toggle(newpositionCollapsed,true);
					// splitter.classList.add(newpositionCollapsed);
					_positionCollapsed = value;
				}
			}
		}

		private var _direction:String;
		protected function get direction():String
		{
			return _direction;
		}
    [Inspectable(category="General", enumeration="horizontal,vertical", defaultValue="horizontal")]
		protected function set direction(value:String):void
		{
				switch (value){
					case "vertical":
					case "horizontal":
						break;
					default:
						throw new Error("Invalid direction: " + value);
				}
				if(_direction){
					toggle(valueToSelector(_direction), false);
				}
				
				toggle(valueToSelector(value), true);
				_direction = value;
				COMPILE::JS{
					if(_splitter){
						_splitter.cursor = value == "horizontal" ? "col-resize" : "row-resize";
						_splitter.touchHitAreaDirection = value;
					}
				}
		}
		COMPILE::JS
		private function handlePointerStart(event:PointerEvent):Boolean{
			if(!isDraggable){
				return false;
			}
			dispatchEvent(new Event(RESIZE_START));
			splitter.toggle("is-dragged",true);
			return true;
		}
		COMPILE::JS
		private function handlePointerEnd():void{
			splitter.toggle("is-dragged",false);
			dispatchEvent(new Event(RESIZE_FINISH));
		}
		COMPILE::JS
		private function handlePointerMove(event:PointerEvent):void{
			var percent:Number;
			var clientRect:ClientRect = element.getBoundingClientRect();
			if(direction == "horizontal"){
				if(clientRect.width == 0){
					return;
				}
				var x:Number = pinValue(event.clientX - clientRect.left,0,clientRect.width);
				percent = getPercent(x,clientRect.width);
			} else{
				if(clientRect.height == 0){
					return;
				}
				var y:Number = pinValue(event.clientY - clientRect.top,0,clientRect.height);
				percent = getPercent(y,clientRect.height);
			}
			_position = percent;
			positionElements(percent);
		}
		
		COMPILE::JS
		public override function addElement(c:IChild, dispatchEvent:Boolean = true):void{
			if(numElements == 1){
				super.addElement(splitter);
			}
			super.addElement(c,dispatchEvent);
			(c as ISpectrumElement).toggle(appendSelector("-pane"),true);
			positionElements(position);
		}
  }
}