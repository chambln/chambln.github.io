articles_src := $(wildcard md/*.md)
articles_obj := $(articles_src:md/%.md=html/%.html)

all: $(articles_obj) css/main.css

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
