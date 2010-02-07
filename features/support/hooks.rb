def demo_feature_files
  Dir.glob('features/*.feature')
end

After do
  #demo_files_after = demo_feature_files
  #to_remove = demo_files_after - @demo_files_before
  if @generated_demos
    @generated_demos.each do |file|
      #puts file
      `rm #{file}`
    end
  end
  #{}`rm features/feature_tagged.feature` if File.exists?('features/feature_tagged.feature')
  #{}`rm features/basic.feature` if File.exists?('features/basic.feature')
end
