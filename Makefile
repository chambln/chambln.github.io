source := md
output := html

# List of markdown files in the source directory.
sources := $(wildcard $(source)/*.md)

# Convert the list of source files into a list of output files.
objects := $(patsubst %.md,%.html,$(subst $(source),$(output),$(sources)))

all: $(objects)

# Recipe for converting a Markdown file into html using pandoc.
$(output)/%.html: $(source)/%.md
	pandoc \
		--standalone \
		--css=../css/main.css \
		--output $@ \
		$<

clean:
	rm -f $(output)/*.html