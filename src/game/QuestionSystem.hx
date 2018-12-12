package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class QuestionNode extends Node<QuestionNode> {
    public var transform:Transform;
    public var sprite:Sprite;
    public var qb:QuestionBlock;
}

class QuestionSystem extends ListIteratingSystem<QuestionNode> {
    private var engine:Engine;
    private var blockSprites:Array<Sprite> = [];
    private var phaserGame:phaser.Game;
    private var playerSprite:Sprite;

    public function new() {
        super(QuestionNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
        phaserGame = whiplash.Lib.phaserGame;
        playerSprite = engine.getEntityByName("player").get(Sprite);
        for(node in nodeList) {
            blockSprites.push(node.sprite);
        }
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    public override function update(dt:Float) {
        super.update(dt);
        phaserGame.physics.arcade.collide(playerSprite, blockSprites, onCollide);
    }

    private function updateNode(node:QuestionNode, dt:Float):Void {
    }

    private function onNodeAdded(node:QuestionNode) {
    }

    private function onNodeRemoved(node:QuestionNode) {
    }

    private function onCollide(a, b) {
        if(a == playerSprite) {
            if(untyped a.body.touching.down && untyped b.body.touching.up) {
                engine.getSystem(ControlSystem).resetJump();
            }
            if(untyped a.body.touching.up && untyped b.body.touching.down) {
                b.tint = 0xFF0000;
            }
        }
    }
}


