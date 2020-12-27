package com.unhurdle.spectrum.colorpicker
{
	import org.apache.royale.html.beads.models.ColorModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IColorWithAlphaModel;

	public class ColorWithAlphaModel extends ColorModel implements IColorWithAlphaModel
	{
        private var _alpha:Number = 1;

        public function get alpha():Number
        {
        	return _alpha;
        }

        public function set alpha(value:Number):void
        {
            if (_alpha != value)
            {
                _alpha = value;
                dispatchEvent(new Event("change"));
            }
        }
	}
}
