package com.unhurdle.spectrum.utils
{
    public class PointerDrag
    {
        COMPILE::SWF
        public function PointerDrag(target:Object, startHandler:Function, moveHandler:Function, endHandler:Function, touchAction:String)
        {
        }

        COMPILE::JS
        public function PointerDrag(target:HTMLElement, startHandler:Function, moveHandler:Function, endHandler:Function, touchAction:String)
        {
            _target = target;
            _startHandler = startHandler;
            _moveHandler = moveHandler;
            _endHandler = endHandler;
            setTouchAction(touchAction);
            _target.addEventListener("pointerdown", handlePointerDown);
        }

        COMPILE::JS
        private var _target:HTMLElement;
        COMPILE::JS
        private var _startHandler:Function;
        COMPILE::JS
        private var _moveHandler:Function;
        COMPILE::JS
        private var _endHandler:Function;
        COMPILE::JS
        private var _pointerId:Number = -1;
        private var _enabled:Boolean = true;

        public function get enabled():Boolean
        {
            return _enabled;
        }

        public function setTouchAction(value:String):void
        {
            COMPILE::JS
            {
                _target.style.touchAction = value;
            }
        }

        public function set enabled(value:Boolean):void
        {
            COMPILE::JS
            {
            if (_enabled == value) {
                return;
            }
            _enabled = value;
            if (!value) {
                cancel();
            }
            }
            COMPILE::SWF
            {
                _enabled = value;
            }
        }

        public function dispose():void
        {
            COMPILE::JS
            {
            cancel();
            _target.removeEventListener("pointerdown", handlePointerDown);
            }
        }

        COMPILE::JS
        private function handlePointerDown(event:PointerEvent):void
        {
            if (!_enabled || _pointerId >= 0 || event.isPrimary === false || event.button != 0) {
                return;
            }
            if (_startHandler(event) === false) {
                return;
            }
            _pointerId = event.pointerId;
            _target.addEventListener("pointermove", handlePointerMove);
            _target.addEventListener("pointerup", handlePointerUp);
            _target.addEventListener("pointercancel", handlePointerCancel);
            _target.addEventListener("lostpointercapture", handleLostPointerCapture);
            _target["setPointerCapture"](_pointerId);
            _moveHandler(event);
        }

        COMPILE::JS
        private function handlePointerMove(event:PointerEvent):void
        {
            if (event.pointerId == _pointerId) {
                _moveHandler(event);
            }
        }

        COMPILE::JS
        private function handlePointerUp(event:PointerEvent):void
        {
            if (event.pointerId == _pointerId) {
                finish();
            }
        }

        COMPILE::JS
        private function handlePointerCancel(event:PointerEvent):void
        {
            if (event.pointerId == _pointerId) {
                finish();
            }
        }

        COMPILE::JS
        private function handleLostPointerCapture(event:PointerEvent):void
        {
            if (event.pointerId == _pointerId) {
                finish();
            }
        }

        COMPILE::JS
        private function cancel():void
        {
            if (_pointerId >= 0) {
                finish();
            }
        }

        COMPILE::JS
        private function finish():void
        {
            var pointerId:Number = _pointerId;
            _pointerId = -1;
            _target.removeEventListener("pointermove", handlePointerMove);
            _target.removeEventListener("pointerup", handlePointerUp);
            _target.removeEventListener("pointercancel", handlePointerCancel);
            _target.removeEventListener("lostpointercapture", handleLostPointerCapture);
            if (_target["hasPointerCapture"](pointerId)) {
                _target["releasePointerCapture"](pointerId);
            }
            _endHandler();
        }
    }
}