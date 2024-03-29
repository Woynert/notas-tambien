import bpy

# Define the specific value for RadiusX and RadiusY
radius_x = 0.3
radius_y = 0.0

# Check if there's an active object and if it's a mesh
if bpy.context.active_object and bpy.context.active_object.type == 'MESH':
    obj = bpy.context.active_object
    
    # Ensure the object is in Object Mode
    bpy.ops.object.mode_set(mode='OBJECT')
    
    # Iterate through each vertex
    #for vertex in obj.data.vertices:
        # Set RadiusX and RadiusY
        #vertex.radius = (radius_x, radius_y)
    #    pass

    #obj = bpy.data.objects['Plane']
    for v in obj.data.skin_vertices[0].data:
        print(v.radius[:])
        v.radius = (radius_x, radius_y)

else:
    print("Please select a mesh object in Object Mode.")
