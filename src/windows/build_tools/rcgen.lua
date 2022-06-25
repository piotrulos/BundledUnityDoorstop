function add_rc(load_events, info, include_resource)
   table.insert(load_events, function(target, import, io)
      import("util", {rootdir="src/windows/build_tools"})
      
      local tmpl_dir = "src/windows/build_tools"

      local resources = ""
      local resource_mapping = ""
      local resource_id = 100

      if include_resource then
         for _, filepath in ipairs(os.files("resources/*")) do
            filename = path.filename(filepath)
            filepath = path.absolute(filepath):gsub("\\", "\\\\")
            if not filename:startswith(".") then
               resource_id = resource_id + 1
               resources =
                  resources .. format("%d RCDATA \"%s\"\r\n", resource_id, filepath)
               resource_mapping = 
                  resource_mapping .. format("{%d, TEXT(\"%s\")},\r\n", resource_id, filename)
               print("Resouce included:", resource_id, "RCDATA", filename)
            end
         end

         util.write_template(
            path.join(tmpl_dir, "resource.c.in"),
            path.join("build", "resource.c"),
            {
               RESOURCE_MAPPING = resource_mapping,
            }
         )
         add_files("build/info.rc")
      end

      util.write_template(
         path.join(tmpl_dir, "info.rc.in"),
         path.join("build", "info.rc"),
         {
            RESOURCES = resources,
            NAME = info.name,
            DESCRIPTION = info.description,
            ORGANIZATION = info.organization,
            MAJOR = info.version.major,
            MINOR = info.version.minor,
            PATCH = info.version.patch,
            RELEASE = info.version.release,
         }
      )
   end)

   if include_resource then add_files("build/resource.c") end
   add_files("build/info.rc")
end