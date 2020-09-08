package com.unhurdle.spectrum
{
  import org.apache.royale.core.UIBase;
  import org.apache.royale.core.CSSClassList;
  COMPILE::JS
  {
  import org.apache.royale.html.util.addElementToWrapper;
  import org.apache.royale.core.WrappedHTMLElement;
  }

  public class SpectrumBase extends UIBase implements ISpectrumElement
  {
    public function SpectrumBase()
    {
      super();
      classList = new CSSClassList();
      typeNames = getSelector();
    }

    protected function getSelector():String{
      return "";
    }
    protected function appendSelector(value:String):String{
      return getSelector() + value;
    }

    protected var classList:CSSClassList;

    public function toggle(classNameVal:String,add:Boolean):void
    {
      COMPILE::JS
      {
        add ? classList.add(classNameVal) : classList.remove(classNameVal);
        setClassName(computeFinalClassNames());
      }
    }
    
    COMPILE::JS
    override protected function computeFinalClassNames():String
    { 
      return (classList.compute() + super.computeFinalClassNames()).trim();
    }
    
    protected function valueToSelector(value:String):String{
      return getSelector() + "--" + value;
    }
    protected function getTag():String{
      return "div";
    }

    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      return addElementToWrapper(this,getTag());
    }

    private var _flexGrow:int = -1;

    public function get flexGrow():int
    {
    	return _flexGrow;
    }

    public function set flexGrow(value:int):void
    {
    	_flexGrow = value;
      COMPILE::JS
      {
        if(value < 0){
          element.style.removeProperty("flex-grow");
        } else {
          element.style.flexGrow = value;
        }

      }
    }

    public function setStyle(property:String,value:Object):void
    {
      COMPILE::JS
      {
        element.style[property] = value;
      }
    }

    public function setAttribute(name:String,value:*):void
    {
      COMPILE::JS
      {
        element.setAttribute(name,value);
      }            
    }
    public function getAttribute(name:String):*
    {
      COMPILE::JS
      {
        return element.getAttribute(name);
      }
      COMPILE::SWF
      {
        return "";
      }
    }
    public function removeAttribute(name:String):void{
      COMPILE::JS
      {
        element.removeAttribute(name);
      }
    }

  }
}