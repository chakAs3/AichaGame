package register.ui.form
{
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;

    public class ECheckBox extends MovieClip
    {
        private var _selected:Boolean = false;
        public var mc_fond:MovieClip;

        public function ECheckBox()
        {
            _selected = false;
            selected = false;
            addEventListener(MouseEvent.CLICK, onClick);
            buttonMode = true;
            return;
        }// end function

        public function set selected(param1:Boolean) : void
        {
            _selected = !param1;
            switchCheck();
            return;
        }// end function

        public function switchCheck() : void
        {
            _selected = !_selected;
            if (_selected)
            {
                TransitionManager.start(mc_fond, {type:Wipe, direction:Transition.IN, duration:0.4, easing:Strong.easeOut});
            }
            else
            {
                TransitionManager.start(mc_fond, {type:Wipe, direction:Transition.OUT, duration:0.4, easing:Strong.easeOut});
            }
            return;
        }// end function

        public function get selected() : Boolean
        {
            return _selected;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            switchCheck();
            return;
        }// end function

    }
}
