
Conject.default_object_context.configure_object :s3 => { :construct  => lambda do |c| 
  S3.new(
    :items => c[:treasure_chest].items
  )
end }
