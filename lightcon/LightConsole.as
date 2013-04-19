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
	public class LightConsole extends Sprite
	{
		/*============================STATIC CONSTANCTS==============================*/
		public static const MAX_LINES			:int = 10;
		public static const LINE_HEIGHT			:int = 15;
		public static const SPACE_ALLOWANCE		:int = 5;
		public static const LINE_NUMBER_WIDTH	:int = 30;
		public static const FONT				:String = "Arial";
		public static const TRANSPARENCY		:Number = 0.5;
		
		/*===========================STATIC VARS====================================*/
		private static var bg					:Shape;
		private static var window				:Stage;
		
		private static var bgHeight				:Number;
		
		private static var lineCount			:int = 0;
		
		private static var string				:String = "";
		
		private static var lines				:Vector.<TextField>;
		private static var lineNumbers			:Vector.<TextField>;
		
		private static var visible				:Boolean = true;
		private static var toggleKey			:uint = Keyboard.F1;
		
		public function LightConsole(window:Stage) 
		{
			LightConsole.window = window;
			LightConsole.bgHeight = LightConsole.MAX_LINES * LINE_HEIGHT + SPACE_ALLOWANCE;
			
			initialize();
		}
		
		private function initialize():void 
		{
			drawConsoleBG();
			initializeNumbers();
			initializeLines();
			
			window.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler );
		
			hide();
			show();
		}
		
		private function initializeNumbers():void 
		{
			var lineNumtextFormat:TextFormat = new TextFormat(LightConsole.FONT, 12, 0xFFFFFF, true, true, false, null, null, TextFormatAlign.RIGHT);
			
			lineNumbers = new Vector.<TextField>(MAX_LINES);
			
			for ( var index:int = 0; index < lineNumbers.length; index++) {
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
		}
		
		private function initializeLines():void 
		{
			var textFormat:TextFormat = new TextFormat(LightConsole.FONT, 12, 0xFFFFFF);
			
			lines = new Vector.<TextField>(LightConsole.MAX_LINES);
			
			for ( var index:int = 0; index < lines.length; index++) {
				lines[index] = new TextField();
				lines[index].defaultTextFormat = textFormat;
				lines[index].selectable = true;
				lines[index].multiline = true;
				lines[index].width = window.stageWidth;
				lines[index].wordWrap = true;
				lines[index].height = window.stageHeight;
				lines[index].x = LINE_NUMBER_WIDTH + SPACE_ALLOWANCE;
				lines[index].y = index * LINE_HEIGHT;
				lines[index].height = LINE_HEIGHT + SPACE_ALLOWANCE;

				this.addChild(lines[index]);
			}
		}
		
		private function keyDownHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case toggleKey:
					if ( LightConsole.visible ) {
						hide();
					}else {
						show();
					}
					break;
				case Keyboard.F3:
					print("Line number " + lineCount, 0xFFFF00);
					break;
			}
		}
		
		public static function hide():void {
			for ( var index:int = 0; index < lines.length; index++) {
				lines[index].visible = false;
				lineNumbers[index].visible = false;
			}
			
			bg.visible = false;
			LightConsole.visible = false;
		}
		
		public static function show():void {
			for ( var index:int = 0; index < lines.length; index++) {
				lines[index].visible = true;
				lineNumbers[index].visible = true;
			}
			
			LightConsole.visible = true;
			bg.visible = true;
		}
		
		private function drawConsoleBG():void {
			bg = new Shape();
			bg.graphics.beginFill( 0x000000, LightConsole.TRANSPARENCY);
			bg.graphics.drawRect(0, 0, window.stageWidth, bgHeight);
			bg.graphics.endFill();
			
			this.addChild(bg);
		}
		
		public static function print(object:Object, textColor:uint = 0xFFFFFF ):void {
			if( window ){
				lineCount++;
				
				if ( LightConsole.lineCount > MAX_LINES) {
					lines.push(lines.shift());
					lineNumbers.push(lineNumbers.shift());
					
					for ( var index:int = 0; index < lines.length; index++) {
						lines[index].y -= LINE_HEIGHT;
						lineNumbers[index].y -= LINE_HEIGHT;
					}
					
					lines[MAX_LINES - 1].y = LINE_HEIGHT * (MAX_LINES - 1);
					lines[MAX_LINES - 1].textColor = textColor;
					lines[MAX_LINES - 1].text = String(object);
					
					lineNumbers[MAX_LINES-1].y = LINE_HEIGHT * (MAX_LINES-1);
					lineNumbers[MAX_LINES - 1].text = lineCount.toString();
					
				}else {
					lines[lineCount - 1].textColor = textColor;
					lines[lineCount-1].text = (String(object));
					lineNumbers[lineCount-1].text = lineCount.toString();
				}
			}else {
				throw(new Error("Call embed(...) first before print(...)"));
			}
			
		}
		
		public static function embed(sprite:Sprite):void {
			if( LightConsole.window == null ){
				sprite.stage.addChildAt(new LightConsole(sprite.stage),0);
			}
		}
		
		public static function setToggleKey(key:uint):void {
			toggleKey = key;
		}
		
	}

}