package utils;

import openfl.system.System;
import flixel.FlxG;
import openfl.Assets;

class MemUtil {
    public static function clear() {
        FlxG.bitmap.dumpCache();
        FlxG.bitmap.clearCache();
        Assets.cache.clear();
        lime.utils.Assets.cache.clear();
        System.gc();
    }
}