package game;

import ash.core.*;
import whiplash.phaser.*;

class BlockNode extends Node<BlockNode> {
    public var sprite:Sprite;
    public var block:Block;
}

class ControlSystem extends ash.core.System {
    private var playerEntity:Entity;
    private var playerSprite:Sprite;
    private var phaserGame:phaser.Game;
    private var blockSprites:Array<Sprite> = [];
    private var mouseEnabled:Bool = true;

    public function new() {
        super();
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        playerEntity = engine.getEntityByName("player");
        playerSprite = playerEntity.get(Sprite);
        phaserGame = whiplash.Lib.phaserGame;
        var list = engine.getNodeList(BlockNode);
        for(node in list) {
            blockSprites.push(node.sprite);
        }
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    public override function update(dt:Float) {
        phaserGame.physics.arcade.collide(playerSprite, blockSprites);
        if(mouseEnabled) {
            var mouseCoords = whiplash.Input.mouseCoordinates;
            var mx = phaserGame.camera.x + mouseCoords.x * 0.5;
            var px = playerSprite.position.x;
            var dx = Math.abs(px - mx);
            var dir = px > mx ? -1 : 1;
            if(dx > 16) {
                untyped playerSprite.body.velocity.x = Math.min(dx, 100) * dir;
            } else {
                untyped playerSprite.body.velocity.x = 0;
            }
            playerEntity.get(Transform).scale.x = dir;
            if(phaserGame.input.mousePointer.isDown) {
                untyped playerSprite.body.velocity.y = -125;
            }
        }
        if(whiplash.Input.keys[" "]) {
        }
    }
}


