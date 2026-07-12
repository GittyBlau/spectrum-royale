package com.unhurdle.spectrum
{
	public class Splitter extends SpectrumBase
	{
		public function Splitter()
		{
			super();
		}
    override protected function getSelector():String{
        return "spectrum-SplitView-splitter";
    }

		private var _draggable:Boolean;

		public function get draggable():Boolean
		{
			return _draggable;
		}

		private var _cursor:String;

		public function get cursor():String
		{
			return _cursor;
		}

		public function set cursor(value:String):void
		{
			_cursor = value;
			if(draggable){
				setStyle("cursor",value);
			}
		}
		COMPILE::JS
		private var touchHitArea:HTMLDivElement;
		public var gripper:HTMLDivElement;
		public function set touchHitAreaDirection(value:String):void
		{
			COMPILE::JS
			{
				if(!touchHitArea){
					return;
				}
				if(value == "horizontal"){
					touchHitArea.style.width = "32px";
					touchHitArea.style.height = "100%";
					touchHitArea.style.top = "0";
					touchHitArea.style.left = "50%";
					touchHitArea.style.transform = "translateX(-50%)";
				} else {
					touchHitArea.style.width = "100%";
					touchHitArea.style.height = "32px";
					touchHitArea.style.top = "50%";
					touchHitArea.style.left = "0";
					touchHitArea.style.transform = "translateY(-50%)";
				}
			}
		}
		public function set draggable(value:Boolean):void
		{
			_draggable = value;
			COMPILE::JS
			{
				if(value){
					if(_cursor){
						setStyle("cursor",_cursor);
					}
					if(!touchHitArea && window.matchMedia("(pointer: coarse)").matches){
						touchHitArea = newElement("div") as HTMLDivElement;
						touchHitArea.style.position = "absolute";
						touchHitArea.style.touchAction = "none";
						touchHitArea.style.cursor = "inherit";
						element.appendChild(touchHitArea);
					}
					if(!gripper){
						gripper = newElement("div","spectrum-SplitView-gripper") as HTMLDivElement;
						element.appendChild(gripper);
					}
				} else {
					setStyle("cursor","");
					if(touchHitArea){
						element.removeChild(touchHitArea);
						touchHitArea = null;
					}
					if(gripper){
						element.removeChild(gripper);
						gripper = null;
					}
				}
			}
		}
	}
}