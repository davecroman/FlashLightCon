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
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author ...
	 */
	public class InGameLightConsole extends Sprite
	{
		/*============================STATIC CONSTANCTS==============================*/
		public static const MAX_LINES:int = 10;
		public static const LINE_HEIGHT:int = 15;
		public static const FONT:String = "Arial";
		public static const TRANSPARENCY:Number = 0.5;
		public static const SPACE_ALLOWANCE = 5;
		public static const LINE_NUMBER_WIDTH = 30;
		
		private static var bg:Shape;
		private static var bgHeight:Number;
		private static var window:Stage;
	
		private static var lineCount:uint = 0;
		private static var string:String = "";
		
		private static var strings:Vector.<TextField>;
		private static var lineNumbers:Vector.<TextField>;
		
		private static var visible:Boolean = true;
		private static var toggleKey:uint;
		
		public function InGameLightConsole(window:Stage) 
		{
			InGameLightConsole.window = window;
			InGameLightConsole.bgHeight = InGameLightConsole.MAX_LINES * LINE_HEIGHT + SPACE_ALLOWANCE;
			
			initialize();
		}
		
		private function initialize():void 
		{
			drawBG();
			
			strings = new Vector.<TextField>(InGameLightConsole.MAX_LINES);
			lineNumbers = new Vector.<TextField>(InGameLightConsole.MAX_LINES);
			
			var index:int;
			
			var lineNumtextFormat:TextFormat = new TextFormat(InGameLightConsole.FONT, 12, 0xFFFFFF, true, true, false, null, null, TextFormatAlign.RIGHT);
			var textFormat:TextFormat = new TextFormat(InGameLightConsole.FONT, 12, 0xFFFFFF);
			
			
			for ( index = 0; index < lineNumbers.length; index++) {
				lineNumbers[index] = new TextField();
				lineNumbers[index].defaultTextFormat = lineNumtextFormat;
				lineNumbers[index].selectable = true;
				lineNumbers[index].multiline = true;
				lineNumbers[index].width = LINE_NUMBER_WIDTH;
				lineNumbers[index].wordWrap = true;
				lineNumbers[index].height = window.stageHeight;
				lineNumbers[index].y = index * LINE_HEIGHT;
				lineNumbers[index].height = LINE_HEIGHT + SPACE_ALLOWANCE;
				
				this.addChild(lineNumbers[index]);
			}
			
			for ( index = 0; index < strings.length; index++) {
				strings[index] = new TextField();
				strings[index].defaultTextFormat = textFormat;
				strings[index].selectable = true;
				strings[index].multiline = true;
				strings[index].width = window.stageWidth;
				strings[index].wordWrap = true;
				strings[index].height = window.stageHeight;
				strings[index].x = LINE_NUMBER_WIDTH + SPACE_ALLOWANCE;
				strings[index].y = index * LINE_HEIGHT;
				strings[index].height = LINE_HEIGHT + SPACE_ALLOWANCE;

				this.addChild(strings[index]);
			}
			
			window.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler );
			toggleKey = Keyboard.F1;
		
			this.hide();
			this.show();
		}
		
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case toggleKey:
					if ( InGameLightConsole.visible ) {
						hide();
					}else {
						show();
					}
					break;
				case Keyboard.F3:
					print("Line number " + lineCount);
					break;
			}
		}
		
		public function hide():void {
			for ( var index:int = 0; index < strings.length; index++) {
				strings[index].visible = false;
				lineNumbers[index].visible = false;
			}
			
			if(this.contains(bg)){
				this.removeChild(bg);
			}
			
			InGameLightConsole.visible = false;
		}
		
		public function show():void {
			for ( var index:int = 0; index < strings.length; index++) {
				strings[index].visible = true;
				lineNumbers[index].visible = true;
			}
			
			InGameLightConsole.visible = true;
			this.addChildAt(bg,0);
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
			lineCount++;
			
			if ( InGameLightConsole.lineCount > MAX_LINES) {
				strings.push(strings.shift());
				lineNumbers.push(lineNumbers.shift());
				
				for ( var index:int = 0; index < strings.length; index++) {
					strings[index].y -= LINE_HEIGHT;
					lineNumbers[index].y -= LINE_HEIGHT;
				}
				
				strings[MAX_LINES-1].y = LINE_HEIGHT * (MAX_LINES-1);
				strings[MAX_LINES-1].text = String(object);
				lineNumbers[MAX_LINES-1].y = LINE_HEIGHT * (MAX_LINES-1);
				lineNumbers[MAX_LINES-1].text = lineCount.toString();
			}else {
				strings[lineCount-1].text = (String(object));
				lineNumbers[lineCount-1].text = lineCount.toString();
			}
			
			
		}
		
		public static function embed(sprite:Sprite):void {
			if( InGameLightConsole.window == null ){
				sprite.stage.addChildAt(new InGameLightConsole(sprite.stage),0);
			}
		}
		
		public static function setToggleKey(key:uint):void {
			toggleKey = key;
		}
		
	}

}