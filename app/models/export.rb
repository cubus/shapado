class Export
  def initialize(group)
    @group = group
  end

  def export_model(model, io, opts = {})
    $stderr.puts ">> Exporting model #{model}"
    selector = opts.delete(:selector) || {:group_id => @group.id}

    puts "selector=#{selector.inspect}"
    model.where(selector).all.each do |object|
      io.write object.to_json({:except => [:_keywords]}.merge(opts)) + "\n"
    end
  end

  def to_file(model, opts = {})
    File.open("#{model.to_s.tableize}.json", "w") do |file|
      export_model(model, file, opts)
    end
  end

  def to_zip(model, zf, opts = {})
    zf.file.open("#{model.to_s.tableize}.json", "w") do |file|
      export_model(model, file, opts)
    end
  end
end
