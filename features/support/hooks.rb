After do
  `rm features/feature_tagged.feature` if File.exists?('features/feature_tagged.feature')
  `rm features/basic.feature` if File.exists?('features/basic.feature')
end