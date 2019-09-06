# red -- static site generator
# MIT License
# 
# Copyright (c) 2019 Gregory L. Chamberlain
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

src_posts := $(shell ls src/posts/*.md | sort -r)
obj_posts := $(src_posts:src/posts/%.md=%.html)
src_pages := $(wildcard src/*.md)
obj_pages := $(src_pages:src/%.md=%.html)

all: $(obj_pages) main.css

index.html: src/index.md archive.html
	pandoc $< -so $@ \
		--verbose \
		--template=template/page \
		-H template/clicky-head.html \
		-A archive.html \
		-B src/header.html \
		--css=main.css

archive_li := $(src_posts:src/posts/%.md=tmp/%.html)

archive.html: $(archive_li) $(obj_posts)
	cat $(archive_li) | pandoc -o archive.html \
		--metadata pagetitle="Archive" \
		--template=template/archive

tmp/%.html: src/posts/%.md
	@mkdir -pv tmp/
	pandoc $< -o $@ \
		--verbose \
		--template=template/archive-li \
		--variable=filename:$(notdir $@)

%.html: src/posts/%.md
	pandoc $< -so $@ \
		--verbose \
		--template=template/post \
		--css=main.css \
		-H template/clicky-head.html \
		-A src/footer.html \
		-B src/header.html \
		--number-sections

%.html: src/%.md
	pandoc $< -so $@ \
		--verbose \
		--template=template/page \
		--css=main.css \
		-H template/clicky-head.html \
		-B src/header.html
%.css: src/%.scss
	sassc $< -t compressed > $@

clean:
	@rm -fv *.html *.css
	@rm -frv tmp/
