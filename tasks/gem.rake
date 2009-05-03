desc 'recreate Manifest'
task :recreate_manifest do
  `git ls-files > Manifest.txt`
end
