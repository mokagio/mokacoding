require 'listen'

desc "Watches the Sass sources for changes and recompiles"
task :watch do

	puts "watching for changes to the Haml and Sass sources.\n"
	puts "note: haml is not implemented yet... x_x"
	Listen.to!('src') do |modified, added, removed|

		def html_path(path)
			html_path = path.gsub 'src/haml/', ''
			html_path = html_path.gsub 'haml', 'html'
			return html_path
		end
		
		def haml_compile(file)
			system "haml #{file} #{html_path(file)}"
			puts "done."
		end

		def css_path(path)
			css_path = path.gsub 'src/sass/', 'css/'
			css_path = css_path.gsub 'sass', 'css'
			return css_path
		end

		def sass_compile(file)
			system "sass #{file} #{css_path(file)}"
			puts "done."
		end

		def compile(file)
			if File.extname(file) == '.haml' 
				haml_compile file
			elsif File.extname(file) == '.sass' 
				sass_compile file
			end
		end		

		def path(file)
			if File.extname(file) == '.haml' 
				html_path file
			elsif File.extname(file) == '.sass' 
				css_path file
			end
		end

		modified.each do |file|
			puts "#{file} changed, recompiling..."
			compile file
		end

		added.each do |file|
			puts "added #{file}, compiling..."
			compile file
		end

		removed.each do |file|
			puts "removed #{file}, removing compiled file as well"
			system "rm #{path(file)}"
		end
	end
end