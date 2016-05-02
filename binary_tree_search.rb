class Node

	attr_accessor :parent, :quantity, :left_node, :right_node

	def initialize(parent, quantity, left_node, right_node)
		@parent = parent
		@quantity = quantity
		@left_node = left_node
		@right_node = right_node
	end
end

def build_tree(arr)
	root = arr.first
	tree = Hash.new
	arr.each{|n| tree[n] = [nil, nil]}
	arr[1..-1].uniq.each{|n|add_element_to_tree(tree, n, root)}
	add_number_of_occurances_of_nodes(arr, tree)
	tree	
end

def add_element_to_tree(tree, element, root)
	if element < root
		add_on_left_side(tree, element, root)
	elsif element >= root
		add_on_right_side(tree, element, root)
	end
end

def add_on_left_side(tree, element, root)
	if tree[root][0].nil?
		# tree[root][1] is in order for the array
		# to maintain the value previously placed there
		tree[root] = [element, tree[root][1]]
		return tree
	else
		new_root = tree[root][0]
		return add_element_to_tree(tree, element, new_root)
	end
end

def add_on_right_side(tree, element, root)
	if tree[root][1].nil?
		# tree[root][0] is in order for the array
		# to maintain the value previously placed there
		tree[root] = [tree[root][0], element]
		return tree
	else
		new_root = tree[root][1]
		return add_element_to_tree(tree, element, new_root)
	end
end

def add_number_of_occurances_of_nodes(arr, tree)
	node_count = []
	arr.each{|n| node_count << [n, arr.count(n)]}
	node_count.uniq!
	# replaces the node with the node and node count
	# ex: 7 becomes [7, 2], 2 being the number of 
	# 7s
	node_count.each do |node|
  	tree[node] = tree.delete(node[0])		
  end
end

def get_root(tree, value)
	tree.keys.each do |node|
		return node if node[0] == value
	end
	return nil
end

def breadth_first_search(tree, target)
	queue = [tree.keys[0]]
	while queue.size > 0
		puts queue.to_s
		tree[queue[0]].each do |n|
			return queue[0] if n == target
			queue << get_root(tree, n) unless n.nil?
		end
		queue.shift
	end
	return nil
end

def nodes_already_visited(tree, visited, nodes)
	return false if nodes.nil?
	nodes_without_nil = nodes.compact
	nodes_without_nil.each do |node|
		unless visited.include?(get_root(tree, node))
			return false
		end
	end
	true
end

def traversing_backward(tree, visited, current_nodes)
	return true if current_nodes == [nil, nil]
	if nodes_already_visited(tree, visited, current_nodes)
		return true
	end
	false
end

def depth_first_search(tree, target)
	visited = [tree.keys[0]]
	stack = [tree.keys[0]]
	side = 0
	while true
		side = tree[stack.last][0].nil? ? 1 : 0
		while traversing_backward(tree, visited, tree[stack.last])
			side = 1
			stack.pop
			return nil if stack.length == 0
		end
		return stack.last if tree[stack.last][side] == target
		stack << get_root(tree, tree[stack.last][side])
		visited << stack.last
	end
end

def format_answer(ans_ary)
	return ans_ary.flatten!
end

def get_parent(tree, target, current_node=tree.keys[0], visited=[], parent=nil)
	visited << current_node
	return [] if current_node.nil?
	if current_node[0] == target
		return parent
	else
		answer = format_answer((get_parent(tree, target, get_root(tree, tree[current_node][0]), visited, current_node) <<
		get_parent(tree, target, get_root(tree, tree[current_node][1]), visited, current_node)))
	end
end

def dfs_rec(tree, target, current_node=tree.keys[0])
	parent = get_parent(tree, target)
	return nil if parent.nil? || parent.empty?
	parent
end

unsorted_ary = [1, 7, 4, 23, 8, 9, 0, 4, 3, 5, 7, 9, 67, 6345, 324]
binary_tree = build_tree(unsorted_ary)
puts binary_tree
nodes = []
binary_tree.each do |parent, child_node|
	nodes << Node.new(parent.first, parent.last, child_node.first, child_node.last)
end
puts breadth_first_search(binary_tree, 67).to_s
#puts depth_first_search(binary_tree, 23).to_s
#puts dfs_rec(binary_tree, 6345).to_s
