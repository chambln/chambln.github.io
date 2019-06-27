sources := $(wildcard md/*.md)
articles := $(patsubst %.md,%.html,$(subst md,html,$(sources)))

all: $(articles) css/main.css

html/%.html: md/%.md
	pandoc $< \
		--output $@ \
		--standalone \
		--css=../css/main.css \
		--template=templates/article.html

css/%.css: sass/%.sass
	sassc $< \
		--sass \
		--style compressed \
		> $@

clean:
	rm -f css/*.css
	rm -f html/*.html
