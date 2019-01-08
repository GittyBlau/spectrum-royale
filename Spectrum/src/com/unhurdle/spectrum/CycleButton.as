package com.unhurdle.spectrum
{
  COMPILE::JS{
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
      import com.unhurdle.spectrum.const.IconPrefix;
      import com.unhurdle.spectrum.const.IconSize;

  public class CycleButton extends SpectrumBase
  {
    public function CycleButton()
    {
      super();
      // we need spectrum-ActionButton spectrum-ActionButton--quiet appended to the classes
      var actionStr:String = "spectrum-ActionButton";
      classList.add(actionStr);
      classList.add(actionStr + "--quiet");
    }
    override protected function getSelector():String{
      return "spectrum-CycleButton";
    }
    private var playIcon:Icon;
    private var pauseIcon:Icon;
    COMPILE::JS
    override protected function createElement():WrappedHTMLElement{
      var elem:WrappedHTMLElement = addElementToWrapper(this,'button');
      // var type:String =
      playIcon = new Icon(IconPrefix._18 + "PlayCircle");
      playIcon.size = IconSize.S;
      playIcon.className = appendSelector("-item is-selected");
      _paused = false;
      addElement(playIcon);
      pauseIcon = new Icon(IconPrefix._18 + "PauseCircle");
      pauseIcon.size = IconSize.S;
      pauseIcon.className = appendSelector("-item");
      addElement(pauseIcon);
      return elem;
    }

    private var _paused:Boolean;

    public function get paused():Boolean
    {
    	return _paused;
    }

    public function set paused(value:Boolean):void
    {
      if(value != _paused){
        if(value){
          pauseIcon.className = appendSelector("-item is-selected");
          playIcon.className = appendSelector("-item");
        } else {
          pauseIcon.className = appendSelector("-item");
          playIcon.className = appendSelector("-item is-selected");
        }
      }
    	_paused = value;
    }
  }
}