package gameplay;

import haxe.Json;

class ChartParser {
    function parse(data:String,diff:String = "") {
        Json.parse(Paths.json('data/${data.toLowerCase()}$diff'));
    }
}