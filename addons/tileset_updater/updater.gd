tool
extends EditorPlugin

# Make this the paths in your scene of the TileMap node
# If it is empty, it will search recursively 
# Not yet implemented

const FIXED_NODE_PATH = []
func refresh_this_node(node):
	if node is TileMap:
		var animation = node.tile_set.tile_get_texture(0)
		if animation is AnimatedTexture:
			var fname_prefix = animation.resource_name
			var first_text = load(fname_prefix + str(0) + '.png')
			var known_image_width = first_text.get_width()
			var known_image_height = first_text.get_height()
			for frame in range(animation.frames):
				var texture = load(fname_prefix + str(frame) + '.png')	
				animation.set_frame_texture(frame, texture)
				
	elif FIXED_NODE_PATH == []:
		for i in node.get_children():
			refresh_this_node(i)
	else:
		for i in FIXED_NODE_PATH:
			pass
	
func refresh_tilesets(arg):
	
	for scene in get_editor_interface().get_open_scenes():
		
		refresh_this_node(load(scene).instance())
	print('Hello world')
	
func _enter_tree():
	# Initialization of the plugin goes here
	add_tool_menu_item("Refresh Animated Tilesets", self, "refresh_tilesets")

func _exit_tree():
	# Clean-up of the plugin goes here
	remove_tool_menu_item("Refresh Animated Tilesets")