package lightcon 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author ...
	 */
	public class InGameLightConsole extends Sprite
	{
		/*============================STATIC CONSTANCTS==============================*/
		public static const MAX_LINES:int = 20;
		public static const HEIGHT_PER_LINE:uint = 16;
		public static const LINE_DELIMITER:String = "\n";
		public static const FONT:String = "Arial";
		public static const TRANSPARENCY:Number = 0.7;
		
		
		private static var bg:Shape;
		private static var window:Stage;
		
		private static var bgHeight:Number;
		private static var textField:TextField;
		private static var lineCount:uint = 0;
		private static var string:String = "";
		
		private static var visible:Boolean = true;
		
		public function InGameLightConsole(window:Stage) 
		{
			InGameLightConsole.window = window;
			InGameLightConsole.bgHeight = InGameLightConsole.MAX_LINES * InGameLightConsole.HEIGHT_PER_LINE;
			InGameLightConsole.textField = new TextField();
			
			initialize();
		}
		
		private function initialize():void 
		{
			drawBG();
			
			InGameLightConsole.textField.defaultTextFormat = new TextFormat(InGameLightConsole.FONT, 12, 0xFFFFFF);
			InGameLightConsole.textField.selectable = false;
			InGameLightConsole.textField.multiline = true;
			InGameLightConsole.textField.antiAliasType = AntiAliasType.ADVANCED;
			InGameLightConsole.textField.sharpness = 100;
			InGameLightConsole.textField.width = window.stageWidth;
			InGameLightConsole.textField.wordWrap = true;
			InGameLightConsole.textField.height = window.stageHeight;
			
			window.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler );
			this.addChild(textField);
			this.hide();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case Keyboard.F1:
					if ( InGameLightConsole.visible ) {
						hide();
					}else {
						show();
					}
					break;
				case Keyboard.F2:
					InGameLightConsole.print("hello");
			}
		}
		
		public function hide():void {
			InGameLightConsole.textField.visible = false;
			
			if(this.contains(bg)){
				this.removeChild(bg);
			}
			
			InGameLightConsole.visible = false;
		}
		
		public function show():void {
			InGameLightConsole.textField.visible = true;
			InGameLightConsole.visible = true;
			this.addChildAt(bg,0);
		}
		
		private static function updateTextField():void 
		{
			textField.text = string;
		}
		
		private function drawBG():void 
		{
			bg = new Shape();
			bg.graphics.beginFill( 0x000000, InGameLightConsole.TRANSPARENCY);
			bg.graphics.drawRect(0, 0, window.stageWidth, bgHeight);
			bg.graphics.endFill();
			
			this.addChild(bg);
		}
		
		public static function print(object:Object):void {
			if ( InGameLightConsole.lineCount >= InGameLightConsole.MAX_LINES) {
				string = string.substring(string.indexOf(InGameLightConsole.LINE_DELIMITER)+1, string.length);
			} else {
				InGameLightConsole.lineCount += 1;
			}
			
			
			string += ( String(object) + InGameLightConsole.LINE_DELIMITER );

			updateTextField();
		}
		
		public static function embed(sprite:Sprite):void {
			if( InGameLightConsole.window == null ){
				sprite.stage.addChildAt(new InGameLightConsole(sprite.stage),0);
			}
		}

		
	}

}