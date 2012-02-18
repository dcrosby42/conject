
module LoadPathHelpers
  def test_data_path(rel_path='')
    "#{PROJECT_ROOT}/spec/test_data/#{rel_path}"
  end

  def append_load_path(path)
    @appended_load_paths ||= []
    @appended_load_paths << path
    $LOAD_PATH << path
  end

  def append_test_load_path(path)
    append_load_path test_data_path(path)
  end

  def restore_load_path
    (@appended_load_paths || []).each do |path|
      remove_load_path path
    end
  end

  def remove_load_path(path)
    $LOAD_PATH.delete path
  end
end

