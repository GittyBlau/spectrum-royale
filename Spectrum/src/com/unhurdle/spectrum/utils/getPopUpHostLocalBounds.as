package com.unhurdle.spectrum.utils
{
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.utils.DisplayUtils;
    import org.apache.royale.utils.PointUtils;
    import org.apache.royale.utils.UIUtils;

    public function getPopUpHostLocalBounds(target:IUIBase):Rectangle
    {
        COMPILE::SWF
        {
            return DisplayUtils.getScreenBoundingRect(target);
        }
        COMPILE::JS
        {
            var bounds:Rectangle = DisplayUtils.getScreenBoundingRect(target);
            var host:IPopUpHost = UIUtils.findPopUpHost(target);
            var hostOrigin:Point = PointUtils.localToViewport(new Point(), host.popUpParent);
            return new Rectangle(
                bounds.x - hostOrigin.x,
                bounds.y - hostOrigin.y,
                bounds.width,
                bounds.height);
        }
    }
}