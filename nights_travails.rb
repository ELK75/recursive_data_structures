class Node

	attr_accessor :parent, :location

	def initialize(parent, location)
		@parent = parent
		@location = location
	end
end

def get_moves(start)
	move_array = [[2, 1], [2, -1], [-2, 1], [-2, -1],
								[1, 2], [1, -2], [-1, 2], [-1, -2]]
	move_stack = []
	move_array.each do |move|
		possible_move = [start[0] + move[0], start[1] + move[1]] 
		move_stack << possible_move if move_valid(possible_move)
	end
	move_stack
end

def does_not_have_move(move_stack, desired_move)
	return true if move_stack.empty?
	move_stack.each do |move|
		return false if move.location == desired_move
	end
	true
end

def find_path(move_stack, end_node, path=[])
	location_array = []
	move_stack.each do |move|
		location_array << move.location
	end
	
	path << end_node
	# this means we've hit the beginning of the stack
	# and we cannot traverse further any more
	if end_node == move_stack[0].location
		path.reverse.each do |moves|
			puts moves.to_s
		end
		return nil
	end

	parent = move_stack[location_array.find_index(end_node)].parent
	return find_path(move_stack, parent, path)

end

def knight_move(start, finish, move_stack=[Node.new(nil, start)], queue=[start], current_node=0)
	get_moves(start).each do |move|
		if does_not_have_move(move_stack, move)
			move_stack << Node.new(start, move)
			queue << move
		end
	end

	current_node += 1

	return find_path(move_stack, finish) if queue.include?(finish)

	return knight_move(queue[current_node], finish, move_stack, queue, current_node)
end

def move_valid(move)
	move.each do |rows|
		return false if rows > 7 || rows < 0
	end
end

knight_move([0, 0], [7, 7]).to_s
