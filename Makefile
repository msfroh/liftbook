RSYNCFLAGS = -rv --delete

all	: master.pdf

html	: master.lyx
	@echo [Building HTML]
#	latex2html -split 3 -local_icons -no_antialias_text -no_antialias -white master.tex
#	./highlightHtml.sh
	rm -rf master/
	mkdir master/
	cp -R templates/* master/
	python elyxer.py --splitpart 1 --css "css/lyx.css" --defaultbrush "scala" --userheader htmlheader.txt --userfooter htmlfooter.txt master.lyx master/index.html
	tar cvzf master.html.tgz master/

exploring_lift.epub	: master.lyx
	rm -rf epub/
	mkdir epub
	python elyxer.py --css lyx.css --nonavigation --noanchors --nofooter --splitpart 1 --defaultbrush "scala" master.lyx epub/index.html
	cp -r epubfiles/* epub
	cp -r images epub
	cd epub && \
	 rm index.html && \
	 rm index-Part* && \
	 rm index-Index.html && \
	 ./massage_file.sh && \
	 zip -0 -X ../exploring_lift.epub mimetype && \
	 zip -r ../exploring_lift.epub META-INF && \
	 zip -r ../exploring_lift.epub images && \
	 zip ../exploring_lift.epub content.opf && \
	 zip ../exploring_lift.epub book.ncx && \
	 zip ../exploring_lift.epub lyx.css && \
	 zip ../exploring_lift.epub index-* && \
	 cd ..

pdf	: master.pdf

master.pdf	: master.aux

master.tex	: *.lyx
	@echo [Exporting PDFLaTeX]
	@lyx -e pdflatex master.lyx

master.aux	: master.tex
	@echo [Building PDF]
	pdflatex master.tex
	makeindex master.idx
	@bash -c "while pdflatex master.tex && grep -q \"Rerun to get cross-references right\" master.log ; do echo \"  Rebuilding references\" ; done"
	@echo [Built PDF]

clean:
	rm -f *.tex images/*.eps *.toc *.aux *.dvi *.idx *.lof *.log *.out *.toc *.lol master.pdf exploring_lift.epub
	rm -rf master/
	rm -rf epub/

install: pdf html
	rsync $(RSYNCFLAGS) master.pdf master.html.tgz lion.harpoon.me:/home/scalatools/hudson/www/exploring/downloads/
	rsync $(RSYNCFLAGS) master/ lion.harpoon.me:/home/scalatools/hudson/www/exploring/master/
