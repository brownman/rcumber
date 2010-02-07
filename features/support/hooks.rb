def demo_feature_files
  Dir.glob('features/*.feature')
end

After do
  if @generated_demos
    @generated_demos.each do |file|
      `rm #{file}`
    end
  end
end
