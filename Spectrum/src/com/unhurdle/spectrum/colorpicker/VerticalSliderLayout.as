package com.unhurdle.spectrum.colorpicker
{

  import org.apache.royale.html.beads.layouts.VerticalSliderLayout;
  import org.apache.royale.core.IUIBase;
  import org.apache.royale.core.IRangeModel;
  import org.apache.royale.html.beads.ISliderView;

  public class VerticalSliderLayout extends org.apache.royale.html.beads.layouts.VerticalSliderLayout
  {
    public function VerticalSliderLayout()
    {
    }

    override public function layout():Boolean
    {
        var viewBead:ISliderView = host.view as ISliderView;
        if (viewBead == null) {
            return false;
        }
        
        var useWidth:Number = host.width;
        if (isNaN(useWidth)) {
            useWidth = 20;
        }
        var useHeight:Number = host.height;
        if (isNaN(useHeight)) {
            useHeight = 100;
        }
        var square:Number = Math.min(useWidth, useHeight);
        var trackWidth:Number = useWidth;
        
        var thumb:IUIBase = viewBead.thumb as IUIBase;
        var track:IUIBase = viewBead.track as IUIBase;
        track.y = 0;
        track.x = 0; 
        track.height = useHeight;
        track.width = trackWidth;
        
        // determine the thumb position from the model information
        var model:IRangeModel = host.model as IRangeModel;
        var value:Number = model.value;
        if (value < model.minimum) value = model.minimum;
        if (value > model.maximum) value = model.maximum;
        var p:Number = (value-model.minimum)/(model.maximum-model.minimum);
        var yloc:Number = p * useHeight;
        thumb.y = yloc;
        thumb.x = trackWidth / 2;
        
        return true;
    }

  }
}
