.PHONY: download db login clean reallyclean tmp
LINK:=static.data.gouv.fr/resources/demandes-de-valeurs-foncieres/20251018-234902/valeursfoncieres-2025-s1.txt.zip
ZIPINPUT:=$(notdir $(LINK))
TXTINPUT:=$(basename $(ZIPINPUT))
FILTEREDINPUT:=$(addsuffix .txt,$(basename $(TXTINPUT))-ORANGE)
DBFILE:=dvf_orange.sqlite3
SQLQUERIES:=all_by_value_desc.sql
CSV:=$(addsuffix .csv,$(basename $(SQLQUERIES)))
HTML:=$(addsuffix .html,$(basename $(SQLQUERIES)))
TARGETS=$(CSV) $(HTML)
all: $(TARGETS)
$(ZIPINPUT):
	wget https://$(LINK)
download: $(ZIPINPUT)
$(TXTINPUT): $(ZIPINPUT)
	unzip $<
	mv "$$(unzip -Z1 $<)" $@
$(FILTEREDINPUT): $(TXTINPUT)	
	grep '|84100|ORANGE|' $< > $@ 
	sed -i 's/,/./g' $@
$(DBFILE): schema.sql $(FILTEREDINPUT)
	@echo 'Rebuilding Database...'
	sqlite3 $@ < schema.sql
	sqlite3 --separator '|' $@ ".import $(FILTEREDINPUT) vf"
db: $(DBFILE)
query: $(TARGETS)
	@echo "Querying database $(DBFILE)"	
login: $(DBFILE)
	sqlite3 -init sqlite3.csv.init $<
%.csv: %.sql $(DBFILE)
	sqlite3 -init sqlite3.csv.init $(DBFILE) < $< > $@
%.html: %.sql $(DBFILE)
	echo '<h3><a href="https://github.com/philippegabriel/immo_db">repo on github</a></h3>' > $@
	echo '<link rel="stylesheet" type="text/css" href="index.css">' >> $@
	date >> $@
	echo '<table border="1">' >> $@
	sqlite3 -init sqlite3.html.init $(DBFILE) < $< >> $@
	echo '</table>' >> $@	
clean:	
	rm -f $(TARGETS)
	rm -f $(DBFILE)
reallyclean: clean
	rm -f $(ZIPINPUT)
	rm -f $(TXTINPUT)
	rm -f $(FILTEREDINPUT)
tmp:
	@echo $(ZIPINPUT)
	@echo $(TXTINPUT)
	@echo $(FILTEREDINPUT)
	echo $$(unzip -Z1 $(ZIPINPUT))
	@echo $(foreach suffix,.csv .html,$(addsuffix $(suffix),$(basename $(SQLQUERIES))))
