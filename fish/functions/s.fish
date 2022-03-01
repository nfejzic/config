function s
	for file in ./*.sublime-project
		echo "Opening the $file"
		subl $file
		return
	end
	echo "Project file doesn't exist, creating one"
	set dirname (basename "$PWD")
	echo "Creating $dirname.sublime-project"
	touch "$dirname.sublime-project"
	echo '{\n    "folders":\n    [\n        {\n            "path": "."\n        }\n    ]\n}' >> "$dirname.sublime-project"
	s .
end
