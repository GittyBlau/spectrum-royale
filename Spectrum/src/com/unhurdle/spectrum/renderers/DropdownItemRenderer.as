package com.unhurdle.spectrum.renderers
{
  import org.apache.royale.html.supportClasses.DataItemRenderer;
  import com.unhurdle.spectrum.data.DropdownItem;
  import com.unhurdle.spectrum.TextNode;
  import com.unhurdle.spectrum.const.IconType;
  import com.unhurdle.spectrum.const.IconPrefix;
  import com.unhurdle.spectrum.Icon;
  import org.apache.royale.html.util.getLabelFromData;
  import com.unhurdle.spectrum.const.IconSize;
  // import org.apache.royale.events.Event;

  COMPILE::JS
  {
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.core.WrappedHTMLElement;
  }
  // [Event(name="itemSelected", type="org.apache.royale.events.Event")]
  public class DropdownItemRenderer extends DataItemRenderer
  {
    public function DropdownItemRenderer()
    {
      super();
      typeNames = '';
    }
    protected function appendSelector(value:String):String{
      return "spectrum-Menu" + value;
    }
    override public function updateRenderer():void{
      // do nothing
    }
    override public function set data(value:Object):void{
      super.data = value;
      // var elem:HTMLElement = element as HTMLElement;
      var dropdownItem:DropdownItem = value as DropdownItem;
      element.className = "";
      if(dropdownItem.isDivider){
        element.className = appendSelector("-divider");
      } else {
        textNode.className = getLabelFromData(this,value);
      }
      if(dropdownItem.disabled){
        element.classList.add("is-disabled");
      }
      if(dropdownItem.selected){
        element.classList.add("is-selected");
      }
      if(dropdownItem.icon){
        if(!icon){
          icon = new Icon(dropdownItem.icon);
          icon.size = IconSize.S;
          element.insertBefore(icon.element,element.childNodes[0] || null);
          icon.addedToParent();
        } else {
          icon.setStyle("display",null);
          icon.selector = dropdownItem.icon;
        }
      } else if(icon){
        icon.setStyle("display","none");
      }
    }
    override public function set selected(value:Boolean):void{
      super.selected = value;
      COMPILE::JS
      {
        if(value){
          element.classList.add("is-selected");
          // element.dispatchEvent(new Event("itemSelected"))
        } else {
          element.classList.remove("is-selected");
        }
      }
    }
    private var icon:Icon;
    private var textNode:TextNode;
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement
    {
      var elem:WrappedHTMLElement = addElementToWrapper(this,'li');
      textNode = new TextNode("span");
      textNode.className = appendSelector("-itemLabel");
      textNode.element.style.userSelect = "none";
      elem.appendChild(textNode.element);

      var type:String = IconType.CHECKMARK_MEDIUM;
      var checkIcon:Icon = new Icon(IconPrefix.SPECTRUM_CSS_ICON + type);
      checkIcon.type = type;
      checkIcon.className = appendSelector("-checkmark");
      addElement(checkIcon);
      
      return elem;
    }
  }
}