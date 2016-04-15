package;

/**
 * ...
 * @author ...
 */

class Timeline {
	public var nodes:Array<TimeNode>;
	public var type:TimeNodeType;
	
	public function new() {
		nodes = new Array<TimeNode>();
	}

	public function value(time:Int):Dynamic {
		// is this before the first time entry?
		if (time <= nodes[0].time) {
			return nodes[0].value;
		}

		// is it after the last?
		if (time >= nodes[nodes.length-1].time) {
			return nodes[nodes.length-1].value;
		}

		// in the middle: walk list until we're between a and a+1
		var position:Int = 0;
		while(true) {
			if (time > nodes[position].time && time <= nodes[position+1].time) {
				return nodes[position].interpolate(time, nodes[position+1], type);
			}
			position++;
		}
	}
}