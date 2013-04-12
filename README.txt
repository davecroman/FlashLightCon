FlashLightCon is a simple in-game console for Flash-based applications.

If you're having trouble connecting to the Flash Debugger (possibly because of version conflict or localhost problems), you can temporarily use FlashLightCon for console-based debugging. It acts as a sprite-based console which you can use on your application to display output of the Flex's trace() method.

Usage:
1. Import the package lightcon on your project.
2. On your main sprite (or any that has access to the stage), add the following lines:

InGameLightConsole.embed(this);

embed accpets Sprite as a parameter. Make sure that object you're passing has access to the stage.

3. Display output on the FlashLightCon console by calling its print(object:Object) method.

InGameLightConsole.print("Hello, world!");

4. When running your application, press F1 to display the console.
