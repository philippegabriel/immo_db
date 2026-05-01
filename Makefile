.PHONY: download db login clean reallyclean tmp
LINK:=https://static.data.gouv.fr/resources/demandes-de-valeurs-foncieres-geolocalisees/20260424-090024/dvf.csv.gz
ZIPINPUT:=$(notdir $(LINK))
TXTINPUT:=$(basename $(ZIPINPUT))
FILTEREDINPUT:=$(addsuffix .txt,$(basename $(TXTINPUT))-ORANGE)
DBFILE:=dvf.sqlite3
SQLQUERIES:=all_by_value_desc.sql
CSV:=$(addsuffix .csv,$(basename $(SQLQUERIES)))
HTML:=$(addsuffix .html,$(basename $(SQLQUERIES)))
TARGETS=$(CSV) $(HTML)
all: $(TARGETS)
$(ZIPINPUT):
	wget -nv $(LINK)
download: $(ZIPINPUT)
$(TXTINPUT): $(ZIPINPUT)
	gunzip -k $<
$(DBFILE): $(TXTINPUT)
	@echo 'Rebuilding Database...'
	sqlite3 $@ < schema.sql
	sqlite3 $@ ".import --csv --skip 1 $(TXTINPUT) dvf"
db: $(DBFILE)
query: $(TARGETS)
	@echo "Querying database $(DBFILE)"	
login: $(DBFILE)
	sqlite3 -init sqlite3.csv.init $<
%.csv: %.sql $(DBFILE)
	sqlite3 -init sqlite3.csv.init $(DBFILE) < $< > $@
%.html: %.sql $(DBFILE)
	sqlite3 -init sqlite3.html.init $(DBFILE) < $< > table.$@
	m4 -Dtableinclude=table.$@ $@.m4 > $@
clean:	
	rm -f $(TARGETS)
	rm -f $(DBFILE)
	rm -f table.*
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
