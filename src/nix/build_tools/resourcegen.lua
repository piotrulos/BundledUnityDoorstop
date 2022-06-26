function add_resource(load_events, include_resource)
   table.insert(load_events, function(target, import, io)
      import("util", {rootdir="src/nix/build_tools"})
      
      local tmpl_dir = "src/nix/build_tools"

      local resource_prefix = "res_"
      local resource_id = 0

      local resource_incbin = ""
      local resource_mapping = ""

      if include_resource then
         for _, filepath in ipairs(os.files("resources/*")) do
            filename = path.filename(filepath)
            filepath = path.absolute(filepath):gsub("\\", "\\\\")
            if not filename:startswith(".") then
               local resource_name = format("%s%d", resource_prefix, resource_id)

               resource_id = resource_id + 1

               resource_incbin = 
                  resource_incbin .. 
                  format("INCBIN(%s, \"%s\");\n", resource_name, filepath)

               resource_mapping = 
                  resource_mapping .. 
                  format("{\"%s\", INCBIN_PREFIX ## %sSize, INCBIN_PREFIX ## %sData},\n", 
                     filename, resource_name, resource_name)
               print("Resouce included:", resource_name, filename)
            end
         end

         util.write_template(
            path.join(tmpl_dir, "resource.c.in"),
            path.join("build", "resource.c"),
            {
               RESOURCE_MAPPING = resource_mapping,
            }
         )
      end
   end)
   
   if include_resource then add_files("build/resource.c") end
end