class ActiveSupport::Cache::FileStore
  def find(pattern)
    Dir[send(:real_file_path, pattern)]
  end
end