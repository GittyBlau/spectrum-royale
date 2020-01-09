package com.unhurdle.spectrum.renderers
{
  import org.apache.royale.html.supportClasses.DataItemRenderer;
  import org.apache.royale.core.CSSClassList;
  COMPILE::JS
  {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
  }

  public class DataItemRenderer extends org.apache.royale.html.supportClasses.DataItemRenderer
  {
		public function DataItemRenderer()
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
    protected function valueToSelector(value:String):String{
      return getSelector() + "--" + value;
    }

    protected var classList:CSSClassList;

    protected function toggle(classNameVal:String,add:Boolean):void
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
      return classList.compute() + super.computeFinalClassNames();
    }
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      return addElementToWrapper(this,'div');
    }

    public function setStyle(property:String,value:Object):void
    {
      COMPILE::JS
      {
        element.style[property] = value;
      }
    }
  }
}