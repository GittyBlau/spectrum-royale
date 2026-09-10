package com.unhurdle.spectrum.utils
{
  public class OutsidePointerTracker
  {
    public function OutsidePointerTracker(elements:Array, outsideHandler:Function)
    {
      this.elements = elements;
      this.outsideHandler = outsideHandler;
    }

    private var elements:Array;
    private var outsideHandler:Function;
    private var tracking:Boolean;

    public function start():void
    {
      COMPILE::JS
      {
        if(tracking){
          return;
        }
        tracking = true;
        document.addEventListener("pointerdown", handlePointerDown, true);
      }
    }

    public function stop():void
    {
      COMPILE::JS
      {
        if(!tracking){
          return;
        }
        tracking = false;
        document.removeEventListener("pointerdown", handlePointerDown, true);
      }
    }

    COMPILE::JS
    private function handlePointerDown(event:PointerEvent):void
    {
      if(!event.isPrimary || event.button != 0){
        return;
      }
      var target:Node = event.target as Node;
      for each(var element:HTMLElement in elements){
        if(element && element.contains(target)){
          return;
        }
      }
      stop();
      outsideHandler();
    }
  }
}