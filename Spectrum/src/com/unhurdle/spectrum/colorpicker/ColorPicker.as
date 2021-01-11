package com.unhurdle.spectrum.colorpicker
{

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import com.unhurdle.spectrum.SpectrumBase;
	import com.unhurdle.spectrum.ColorSwatch;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.MouseEvent;
	import com.unhurdle.spectrum.interfaces.IRGBA;
	import com.unhurdle.spectrum.data.RGBColor;
	import com.unhurdle.spectrum.interfaces.IColorPopover;
	import org.apache.royale.utils.DisplayUtils;
	import com.unhurdle.spectrum.utils.getDataProviderItem;
	import org.apache.royale.events.ValueEvent;

	[Event(name="colorChanged", type="com.unhurdle.spectrum.events.ColorChangeEvent")]
	[Event(name="colorCommit", type="org.apache.royale.events.ValueEvent")]
	[Event(name="cancel", type="org.apache.royale.events.Event")]
	public class ColorPicker extends SpectrumBase
	{

		public function ColorPicker()
		{
			super();
		}

		private var _position:String = "bottom";
		public function get position():String{
			return _position;
		}

		public function set position(value:String):void{
			_position = value;
		}

		public function get colorValue():uint{
			if(!appliedColor){
				return 0;
			}
			return appliedColor.colorValue;
		}

		public function set colorValue(value:uint):void{
			var color:RGBColor = new RGBColor();
			color.colorValue = value;
			appliedColor = color;
		}
		
		private var _button:ColorSwatch;
		public function get appliedColor():IRGBA{
			return _button.color;
		}

		public function set appliedColor(value:IRGBA):void{
			_button.color = value;
		}
		private var _dataProvider:Object;
		public function get dataProvider():Object{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void{
			_dataProvider = value;
		}
		private var _applyText:String = "Apply";
		public function get applyText():String{
			return _applyText;
		}
		public function set applyText(value:String):void{
			_applyText = value;
		}

		private var _cancelText:String = "Cancel";
		public function get cancelText():String{
			return _cancelText;
		}
		public function set cancelText(value:String):void{
			_cancelText = value;
		}

		private var _showApplyButtons:Boolean;
		public function get showApplyButtons():Boolean{
			return _showApplyButtons;
		}
		public function set showApplyButtons(value:Boolean):void{
			_showApplyButtons = value;
		}

		private var _showColorControls:Boolean = true;
		public function get showColorControls():Boolean{
			return _showColorControls;
		}
		public function set showColorControls(value:Boolean):void{
			_showColorControls = value;
		}

		private var _showAlphaControls:Boolean = true;
		public function get showAlphaControls():Boolean{
			return _showAlphaControls;
		}
		public function set showAlphaControls(value:Boolean):void{
			_showAlphaControls = value;
		}

		private var _showSelectionSwatch:Boolean = true;
		public function get showSelectionSwatch():Boolean{
			return _showSelectionSwatch;
		}
		public function set showSelectionSwatch(value:Boolean):void{
			_showSelectionSwatch = value;
		}
		/**
		 * technically the default be 192 and should be 240 on mobile, but we're setting it to 196 to fit the swatch list
		 */
		private var _areaSize:Number = 196;
		public function get areaSize():Number{
			return _areaSize;
		}
		public function set areaSize(value:Number):void{
			_areaSize = value;
		}
		
		private function createButton():ColorSwatch{
			var button:ColorSwatch = new ColorSwatch();
			button.size = 24;
			button.setStyle("cursor","pointer");
			button.addEventListener("click",togglePopover);
			return button;
		}
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement{
			var elem:WrappedHTMLElement = super.createElement();
			_button = createButton();
			addElement(_button);
			// popover = new ComboBoxList();
			// popover.className = appendSelector("-popover");
			// popover.addEventListener("openChanged",handlePopoverChange);
			// // popover.percentWidth = 100;
			// // popover.style = {"z-index":100};//????
			// // menu = new Menu();
			// // popover.addElement(menu);
			// menu.addEventListener("change", handleListChange);
			// menu.percentWidth = 100;
			// popover.style = {"z-index": "2"};
			return elem;
		}

		override public function addedToParent():void{
			if(!appliedColor && dataProvider){
				appliedColor = getDataProviderItem(dataProvider,0) as IRGBA;
			}
			super.addedToParent();
		}
		private var _popover:IColorPopover;

		public function set popover(value:IColorPopover):void
		{
			_popover = value;
		}

		public function get popover():IColorPopover{
			if(!_popover){            
				var c:Class = ValuesManager.valuesImpl.getValue(this, "iColorPopover") as Class;
				if(c){
					_popover = new c() as IColorPopover;
				}
				if(_popover){
					_popover.addEventListener("colorChanged",handleColorChange);
					_popover.addEventListener("colorCommit",handleColorCommit);
					_popover.addEventListener("cancel",handleCancel);
				}
			}
			return _popover;
		}
		protected function handleColorChange(ev:ValueEvent):void{
			_button.color = ev.value;
			dispatchEvent(ev);
		}
		protected function handleColorCommit(ev:ValueEvent):void{
			dispatchEvent(ev);
		}
		protected function handleCancel(ev:ValueEvent):void{
			dispatchEvent(ev);
		}
		protected function togglePopover(ev:Event):void{
			ev.preventDefault();
			var open:Boolean = !popover.open;
			if(open){
				// dispatchEvent(new Event("showMenu"));
				COMPILE::JS
				{
					requestAnimationFrame(openPopup);
				}
			} else {
				closePopup();
			}
		}
		protected function setPopupProperties():void{
			popover.position = position;
			if(!appliedColor){
				appliedColor = new RGBColor([0,0,0,1]);
			}
			popover.appliedColor = appliedColor;
			popover.dataProvider = dataProvider;
			popover.applyText = applyText;
			popover.cancelText = cancelText;
			popover.showApplyButtons = showApplyButtons;
			popover.showColorControls = showColorControls;
			popover.showAlphaControls = showAlphaControls;
			popover.showSelectionSwatch = showSelectionSwatch;
			popover.areaSize = areaSize;			
		}
		protected function openPopup():void{
			popover.anchor = DisplayUtils.getScreenBoundingRect(_button);
			setPopupProperties();
			popover.open = true;
			_button.addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			popover.addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
		protected function closePopup():void{
			if(popover && popover.open){
				popover.removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
				_button.removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
				topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
				popover.open = false;
			}
		}
		protected function handleControlMouseDown(event:MouseEvent):void{
			event.stopImmediatePropagation();
		}
		protected function handleTopMostEventDispatcherMouseDown(event:MouseEvent):void{
			closePopup();
		}

	}
}
/**
 * Options:
 * Selection Closes -- Could be dependent on Apply and Cancel buttons.
 * Only swatches
 * Opacity slider
 * Hex value editable
 * Apply Button (set via label)
 * Cancel button (ditto)
 * Compare old/new values
 * 
 */
/**
 * Notes:
 * Use Color Sliders
 * Use Color Slider styling for swatches
 * Ditto for main swatch
 * Sample color swatch seems to not have rounded corners in Adobe's design and it's 32px instead of 24.
 */