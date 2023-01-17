package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxG;

using StringTools;

class WalkingCrewmate extends FlxSprite {

    public var thecolor:String;
    public var xRange:Array<Float> = [0, 0];
    public var yHeight:Float = 0;
    
    var idle:Bool = false;
    var nextActionTime:Float;
    var time:Float;
    var savedHeight:Float;

    var right:Bool;

    var hibernating:Bool = false;
    var cloneCount:Int = 0;

    public function new(theColor:Int, range:Array<Float>, height:Float, thescale:Float)
    {
        super(FlxG.random.float(range[1] - range[0]), height);   

        xRange = range;
        //yHeight = height; 
        savedHeight = height;
        scale.set(thescale, thescale);

        lookupColor(theColor);

        frames = Paths.getSparrowAtlas('mira/walkers', 'impostor');	
	    animation.addByPrefix('walk', thecolor, 24, true);
        animation.addByIndices('idle', thecolor, [8], "", 24, true);
	    animation.play('walk');
	    antialiasing = true;
	    scrollFactor.set(1, 1);

        setNewActionTime();
    }

    function lookupColor(h:Int){
        switch(h){
            case 0:
                thecolor = 'blue';
                y = savedHeight + 70;
            case 1:
                thecolor = 'brown';
                y = savedHeight;
            case 2:
                thecolor = 'lime';
                y = savedHeight + 70;
            case 3:
                thecolor = 'tan';
                y = savedHeight;
            case 4:
                thecolor = 'white'; 
                y = savedHeight;
            case 5:
                thecolor = 'yellow'; 
                y = savedHeight;
        }
    }

    function swapSkin(){
        nextActionTime = time + FlxG.random.float(5, 10);
        visible = false;
        animation.stop();
        animation.remove('walk');
        animation.remove('idle');
        var newColor:Int = 0;
        lookupColor(newColor);
        animation.addByPrefix('walk', thecolor, 24, true);
        animation.addByIndices('idle', thecolor, [8], "", 24, true);
        if(newColor == 0 && thecolor == "blue") { cloneCount += 1; newColor = 2; }
        if(newColor == 1 && thecolor == "brown") { cloneCount += 1; newColor = 5; }
        if(newColor == 2 && thecolor == "lime") { cloneCount += 1; newColor = 3; }
        if(newColor == 3 && thecolor == "tan") { cloneCount += 1; newColor = 1; }
        if(newColor == 4 && thecolor == "white") { cloneCount += 1; newColor = 0; }
        if(newColor == 5 && thecolor == "yellow") { cloneCount += 1; newColor = 4; }
    }

    function setNewActionTime(){
        nextActionTime = time + FlxG.random.float(0.5, 1);
    }

    function triggerNextAction(){

        if(hibernating == true){
            hibernating = false;
            visible = true;
        }

        if(FlxG.random.bool(20))
            right = FlxG.random.bool(50);

        if(idle == false && FlxG.random.bool(60)){
            idle = true;
        }
        if(idle == true && FlxG.random.bool(50)){
            idle = false;
        }
        setNewActionTime();
    }

    override function update(elapsed:Float) {

        time += elapsed;

        if(time > nextActionTime){
            triggerNextAction();
        }

        super.update(elapsed);
        
        if(hibernating == false){

            if(x > (xRange[1] * 0.9)){
                hibernating = true;
                x -= 50;
                right = false;
                swapSkin();
            }
    
            if(x < (xRange[0] * 1.1)){
                hibernating = true;
                x += 50;
                right = true;
                swapSkin();
            }
            
            if(idle == false){
                if(animation.curAnim.name != 'walk')
                    animation.play('walk');
    
                if(right == true){
                    x = FlxMath.lerp(x, x + 30, CoolUtil.boundTo(elapsed * 9, 0, 1));
                    flipX = false;
                }else{
                    x = FlxMath.lerp(x, x - 30, CoolUtil.boundTo(elapsed * 9, 0, 1));
                    flipX = true;
                }
            }else{
                if(animation.curAnim.name != 'idle' && (animation.curAnim.curFrame == 7 || animation.curAnim.curFrame == 15))
                    animation.play('idle');
    
                if(right == true){
                    flipX = false;
                }else{
                    flipX = true;
                }
            }

            if(x > xRange[1]){
                right = false;
            }
    
            if(x < xRange[0]){
                right = true;
            }
        }
        
        
    }
}