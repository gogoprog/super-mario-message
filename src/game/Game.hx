package game;

import js.Lib;
import js.jquery.*;
import js.Browser.document;
import js.Browser.window;
import phaser.Game;
import phaser.Phaser;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import whiplash.*;
import whiplash.math.*;
import whiplash.phaser.*;
import whiplash.common.components.Active;

class Game {
    var engine:ash.core.Engine;

    public function new() {
        new JQuery(window).on("load", function() {
            whiplash.Lib.init(640, 480, ".root", {preload:preload, create:create, update:update});
            engine = whiplash.Lib.ashEngine;
        });
    }

    function preload():Void {
        Factory.preload(whiplash.Lib.phaserGame);
    }

    function create():Void {
        Factory.init(whiplash.Lib.phaserGame);
        whiplash.Input.setup(document.querySelector(".root"));

        var e = Factory.createSky();
        engine.addEntity(e);
        var e = Factory.createLevel();
        engine.addEntity(e);
    }

    function update():Void {
        var dt = whiplash.Lib.getDeltaTime() / 1000;
        engine.update(dt);
        if(whiplash.Input.mouseButtons[0]) {
            trace(whiplash.Input.mouseCoordinates);
        }
    }

    static function main():Void {
        new Game();
    }
}
