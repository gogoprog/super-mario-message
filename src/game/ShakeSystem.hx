package game;

import ash.tools.ListIteratingSystem;
import ash.core.*;
import whiplash.phaser.*;

class ShakeNode extends Node<ShakeNode> {
    public var transform:Transform;
    public var shake:Shake;
}

class ShakeSystem extends ListIteratingSystem<ShakeNode> {
    private var engine:Engine;

    public function new() {
        super(ShakeNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        this.engine = engine;
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    private function updateNode(node:ShakeNode, dt:Float):Void {
        var shake = node.shake;
        var p = node.transform.position;
        var speed:Float = 20;

        shake.time += dt;

        p.y = shake.y - (Math.sin(shake.time * speed - Math.PI/2) + 1) * 4;

        if(shake.time * speed > Math.PI * 2) {
            p.y = shake.y;
            node.entity.remove(Shake);
        }
    }

    private function onNodeAdded(node:ShakeNode) {
        var shake = node.shake;
        var p = node.transform.position;
        shake.y = p.y;
    }

    private function onNodeRemoved(node:ShakeNode) {
    }
}


