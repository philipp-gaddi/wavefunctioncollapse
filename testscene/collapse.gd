extends Object
class_name Collapse


# assumptions:
# vertex have a field called superposition, which is an array of possible values: blue, yellow, brown
# the ruleset is a dictionary with values and their possible neighbours 

const SUPERPOSITION = "superposition"

var wave_function:Graph
var stack:Array
var ruleset:Dictionary

func _init(wave_function_:Graph, collapsed_vertex_:Vertex, ruleset_:Dictionary):
	
	self.wave_function = wave_function_
	collapsed_vertex_.visited = true
	self.stack = [collapsed_vertex_]
	self.ruleset = ruleset_

func collapse():
	
	var vertex:Vertex
	var neighbour_superposition_update:Array
	
	while not stack.empty():
		
		vertex = stack.pop_back()
		vertex.visited = true
		
		# create the possible superposition for the neighbouring 
		# vertices, which is the intersection its own superposition
		# right hand side.
		neighbour_superposition_update = get_superposition_update(vertex.data[SUPERPOSITION])
		
		for v in wave_function.neighbours(vertex):
			
			if not v.visited:
				v.data[SUPERPOSITION] = intersection(neighbour_superposition_update, 
														v.data[SUPERPOSITION])
				v.visited = true
				stack.push_front(v)
	
	wave_function.reset_visited()

func union(set_A:Array, set_B:Array) -> Array:
	
	var set_union:Array = set_A.duplicate()
	
	for v in set_B:
		if not v in set_A:
			set_union.append(v)
	
	return set_union

func intersection(set_A:Array, set_B:Array) -> Array:
	
	var set_intersection = []
	
	for v in set_A:
		if v in set_B:
			set_intersection.append(v)
	
	return set_intersection

func get_superposition_update(superposition:Array):
	
	var superposition_update = []
	for s in superposition:
		
		for r in ruleset[s]:
			if not r in superposition_update:
				superposition_update.append(r)
		
	return superposition_update
	
